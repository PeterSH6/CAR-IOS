#include "GridSamplerFunction.h"
#include <iostream>

using namespace std;

torch::Tensor GridSamplerFunction::forward(torch::Tensor img, torch::Tensor kernels, torch::Tensor offsets_h, torch::Tensor offsets_v, const int offset_unit, const int padding, const int downscale_factor, const string pad2d_filepath)
{
	int b = img.size(0);
	int c = img.size(1);
	int h = img.size(2);
	int w = img.size(3);

	assert(int(h / downscale_factor) == kernels.size(2));
	assert(int(w / downscale_factor) == kernels.size(3));

    torch::jit::script::Module ReflectionPad2d = torch::jit::load(pad2d_filepath);
    at::Tensor padded_img = ReflectionPad2d.forward({img}).toTensor();

    //at::Tensor output = padded_img.new_zeros();
    at::Tensor output = torch::zeros({ b, c, int(h / downscale_factor), int(w / downscale_factor) },padded_img.options());   // 初始化输出

    adaptive_gridsampler_kernel_forward(padded_img, kernels, offsets_h, offsets_v, offset_unit, padding, output);

	return output;
}

template <typename scalar_t> void GridSamplerFunction::kernel_adaptive_gridsampler_update_output(const torch::Tensor img, const torch::Tensor kernels, const torch::Tensor offsets_h, const torch::Tensor offsets_v, const int offset_unit, const int padding, torch::Tensor& output, const size_t global_idx)
{
    auto dim_b = output.size(0);
    auto dim_c = output.size(1);
    auto dim_h = output.size(2);
    auto dim_w = output.size(3);

    auto idb = (global_idx / (dim_c * dim_h * dim_w)) % dim_b;
    auto idc = (global_idx / (dim_h * dim_w)) % dim_c;
    auto idy = (global_idx / dim_w) % dim_h;
    auto idx = global_idx % dim_w;

    if (idx >= dim_w || idy >= dim_h)
        return;

    int k_size = sqrt(float(kernels.size(1)));
    float w = float(img.size(3) - 2 * padding);
    float h = float(img.size(2) - 2 * padding);

    scalar_t result = 0;
    for (int k_y = 0; k_y < k_size; ++k_y)
    {
        for (int k_x = 0; k_x < k_size; ++k_x)
        {
            scalar_t offset_h = offsets_h[idb][k_size * k_y + k_x][idy][idx].item().toFloat() * offset_unit;
            scalar_t offset_v = offsets_v[idb][k_size * k_y + k_x][idy][idx].item().toFloat() * offset_unit;

            scalar_t p_x = static_cast<scalar_t>(idx + 0.5) / dim_w * w + k_x + offset_h - 0.5;
            scalar_t p_y = static_cast<scalar_t>(idy + 0.5) / dim_h * h + k_y + offset_v - 0.5;
            scalar_t alpha = p_x - floor(p_x);
            scalar_t beta = p_y - floor(p_y);

            int xL = max(min(int(floor(p_x)), int(w + 2 * padding - 1)), 0);
            int xR = max(min(xL + 1, int(w + 2 * padding - 1)), 0);
            int yT = max(min(int(floor(p_y)), int(h + 2 * padding - 1)), 0);
            int yB = max(min(yT + 1, int(h + 2 * padding - 1)), 0);

            scalar_t val = 0;
            val += (1 - alpha) * (1 - beta) * img[idb][idc][yT][xL].item().toFloat();
            val += alpha * (1 - beta) * img[idb][idc][yT][xR].item().toFloat();
            val += (1 - alpha) * beta * img[idb][idc][yB][xL].item().toFloat();
            val += alpha * beta * img[idb][idc][yB][xR].item().toFloat();

            result += val * kernels[idb][k_size * k_y + k_x][idy][idx].item().toFloat();
        }
    }
    output[idb][idc][idy][idx] = result;
}

void GridSamplerFunction::adaptive_gridsampler_kernel_forward(const torch::Tensor& img, const torch::Tensor& kernels, const torch::Tensor& offsets_h, const torch::Tensor& offsets_v, const int offset_unit, const int padding, torch::Tensor& output)
{
    auto dim_b = output.size(0);
    auto dim_c = output.size(1);
    auto dim_h = output.size(2);
    auto dim_w = output.size(3);

    size_t output_numel = dim_b * dim_c * dim_h * dim_w;

    for (size_t global_idx = 0; global_idx < output_numel; ++global_idx) {
        kernel_adaptive_gridsampler_update_output<float>(img, kernels, offsets_h, offsets_v, offset_unit, padding, output, global_idx);
    }
}
