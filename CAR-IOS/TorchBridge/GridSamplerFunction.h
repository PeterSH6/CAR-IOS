#pragma once

#include <LibTorch/LibTorch.h>

#define BLOCK_SIZE 256

class GridSamplerFunction{
public:
	static torch::Tensor forward(torch::Tensor img, torch::Tensor kernels, torch::Tensor offsets_h, torch::Tensor offsets_v, const int offset_unit, const int padding, const int downscale_factor);

private:
	template <typename scalar_t> static void kernel_adaptive_gridsampler_update_output(
		const torch::Tensor img,
		const torch::Tensor kernels,
		const torch::Tensor offsets_h,
		const torch::Tensor offsets_v,
		const int offset_unit,
		const int padding,
		torch::Tensor& output,
		const size_t global_idx);

	static void adaptive_gridsampler_kernel_forward(const torch::Tensor& img, const torch::Tensor& kernels, const torch::Tensor& offsets_h, const torch::Tensor& offsets_v, const int offset_unit, const int padding, torch::Tensor& output);
};

