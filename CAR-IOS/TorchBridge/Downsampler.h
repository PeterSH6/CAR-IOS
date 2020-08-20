#pragma once

#include "GridSamplerFunction.h"

class Downsampler
{
public:
	Downsampler();

	static torch::Tensor forward(torch::Tensor image, torch::Tensor cat_kernel, int ds, int k_size, int offset_unit, const at::string pad2d_filepath);
    
//    static torch::Tensor forward(torch::Tensor img, torch::Tensor kernels, torch::Tensor offsets_h, torch::Tensor offsets_v, const int offset_unit, const int padding, const int downscale_factor, const at::string pad2d_filepath);
//
//    static torch::Tensor Transpose(torch::Tensor tensor);
//
//private:
//    template <typename scalar_t> static void kernel_adaptive_gridsampler_update_output(
//        const torch::Tensor img,
//        const torch::Tensor kernels,
//        const torch::Tensor offsets_h,
//        const torch::Tensor offsets_v,
//        const int offset_unit,
//        const int padding,
//        torch::Tensor& output,
//        const size_t global_idx);
//
//    static void adaptive_gridsampler_kernel_forward(const torch::Tensor& img, const torch::Tensor& kernels, const torch::Tensor& offsets_h, const torch::Tensor& offsets_v, const int offset_unit, const int padding, torch::Tensor& output);
//    
//
};
