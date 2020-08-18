#include "Downsampler.h"

Downsampler::Downsampler(int ds, int k_size, int offset_unit)
{
	this->ds = ds;
	this->k_size = k_size;
	this->offset_unit = offset_unit;
}

torch::Tensor Downsampler::forward(torch::Tensor image, torch::Tensor cat_kernel)
{
	assert(pow(k_size, 2) == cat_kernel.size(1));

	torch::Tensor kernels;
	torch::Tensor offsets_h;
	torch::Tensor offsets_v;

	kernels = cat_kernel[0].unsqueeze(0);
	offsets_h = cat_kernel[1].unsqueeze(0);
	offsets_v = cat_kernel[2].unsqueeze(0);

	return GridSamplerFunction::forward(image, kernels, offsets_h, offsets_v, offset_unit, int(k_size / 2), ds);
}
