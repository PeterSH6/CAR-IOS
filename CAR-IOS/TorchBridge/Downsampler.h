#pragma once

#include "GridSamplerFunction.h"

class Downsampler
{
public:
	Downsampler();

	static torch::Tensor forward(torch::Tensor image, torch::Tensor cat_kernel, int ds, int k_size, int offset_unit, const at::string pad2d_filepath);
};
