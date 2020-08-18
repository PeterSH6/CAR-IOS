#pragma once

#include "GridSamplerFunction.h"

class Downsampler :torch::nn::Module
{
private:
	int ds;
	int k_size;
	int offset_unit;

public:
	Downsampler(int ds, int k_size, int offset_unit);

	torch::Tensor forward(torch::Tensor image, torch::Tensor cat_kernel);
};