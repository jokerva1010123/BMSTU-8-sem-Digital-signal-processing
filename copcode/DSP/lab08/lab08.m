function lab08
	t_max = 3;
	dt = 0.05;
	x = -t_max:dt:t_max;
	yx = gaussian(x);
	uxbase = gaussian(x);
	ux = gaussian(x);
	N = length(yx);

	a = 0.25;
	epsv = 0.05;

	px = a .* rand(1, 20);

	pos = [25, 35, 40, 54, 67, 75, 95];
	pxx = length(pos);

	for i = 1 : 1 : pxx
		ux(pos(i)) = ux(pos(i)) + px(i);
		uxbase(pos(i)) = uxbase(pos(i)) + px(i);
	end

	for i = 1 : 1 : N
		smthm = mean(ux, i);
		if (abs(ux(i) - smthm) > epsv)
			ux(i) = smthm;
		end
	end

	graph_figure(1, x, uxbase, ux, 'Mean');

	uxbase = gaussian(x);
	ux = gaussian(x);

	for i = 1 : 1 : pxx
		ux(pos(i)) = ux(pos(i)) + px(i);
		uxbase(pos(i)) = uxbase(pos(i)) + px(i);
	end

	for i = 1 : 1 : N
		smthm = med(uxbase, i);
		if (abs(ux(i) - smthm) > epsv)
			ux(i) = smthm;
		end
	end

	graph_figure(2, x, uxbase, ux, 'Med');
end

function y = mean(ux, i)
	r = 0;
	imin = i - 2;
	imax = i + 2;
	for j = imin : 1 : imax
		if (j > 0 && j < (length(ux) + 1))
			r = r + ux(j);
		end
	end
	r = r / 5;
	y = r;
end

function y = med(ux, i)
	imin = i - 1;
	imax = i + 1;
	if (imin < 1)
		y = ux(imax);
	else
		if (imax > length(ux))
			y = ux(imin);
		else
			if (ux(imax) > ux(imin))
				y = ux(imin);
			else
				y = ux(imax);
			end
		end
	end
end

% Gaussian pulse generation
function y = gaussian(x)
	A = 1.0;
	sigma = 1.0;
	y = A * exp(-x.^2 / sigma^2);
end

function graph_figure(i, x, y, u, tit)
	figure(i)
	plot(x, y, x, u);
	title(tit);
	legend('Исходный сигнал', 'Сглаженный сигнал');
	print(strcat('plot08_', num2str(i)), '-dpng');
end
