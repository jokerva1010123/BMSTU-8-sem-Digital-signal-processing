function lab_09()

MOTION_LEN = 20;
MOTION_ANGLE = 30;
GAUSSIAN_SIZE = 15;
GAUSSIAN_DEVIATION = 10;
VAR_NOISE = 0.00005;
IMAGE_COLOR_DEPTH=8

img=double(imread('image.bmp'))/(2^IMAGE_COLOR_DEPTH);
figure, imshow (img);
title ("Original image");

psf = fspecial("motion", MOTION_LEN, MOTION_ANGLE);
estimated_nsr = VAR_NOISE / (var(img(:)) - VAR_NOISE);
recovered = deconvwnr (img, psf, estimated_nsr);
figure, imshow (recovered)
title ({"Restored image (Motion Blur)"});

psf = fspecial("gaussian", GAUSSIAN_SIZE, GAUSSIAN_DEVIATION);
estimated_nsr = VAR_NOISE / (var(img(:)) - VAR_NOISE);
recovered = deconvwnr (img, psf, estimated_nsr);
figure, imshow (recovered)
title ({"Restored image (Gaussian Blur)"});
end




