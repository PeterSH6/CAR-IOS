#pragma once

#include "GridSamplerFunction.h"

class Downsampler :torch::nn::Module
{
public:
	Downsampler();

	static torch::Tensor forward(torch::Tensor image, torch::Tensor cat_kernel, int ds, int k_size, int offset_unit);
};
