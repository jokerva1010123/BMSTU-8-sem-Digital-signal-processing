function lab06
	% Входные параметры
	A = 1.0;
	sigma = 0.5;

	% ОДЗ
	t_max = 5;
	dt = 0.005;
	t = -t_max:dt:t_max;

	% Генерация сигнала Гаусса
	x0 = gaussian(t, A, sigma);

	% Генерация Гауссовых помех
	NA = 0;
	NS = 0.05;
	n1 = normrnd(NA, NS, [1 length(x0)]);
	x1 = x0 + n1;

	% Генерация импульсных помех
	count = 7;
	M = 0.4;
	n2 = impulse_noise(length(x0), count, M);
	x2 = x0 + n2;

	% Фильтрация
	y1 = wiener_filter(fft(x1), fft(n1));
	y2 = wiener_filter(fft(x2), fft(n2));

	graph_figure(1, t, x1, y1, 'Гауссовы помехи')
	graph_figure(2, t, x2, y2, 'Импульсные помехи')
end

function graph_figure(i, t, x, y, tit)
	figure(i)
	plot(t, x, t, ifft(fft(x) .* y));
	title(tit);
	legend('С помехами', 'После фильтрации');
	print(strcat('plot06_', num2str(i)), '-dpng');
end

% Gaussian pulse generation
function y = gaussian(x, A, sigma)
	y = A * exp(-(x / sigma) .^ 2);
end

% Impulsive noise generation
function y = impulse_noise(size, N, mult)
	step = floor(size / N);
	y = zeros(1, size);
	for i = 0:floor(N / 2)
		y(round(size / 2) + i * step) = mult * (0.5 + rand);
		y(round(size / 2) - i * step) = mult * (0.5 + rand);
	end
end

function y = wiener_filter(x, n)
	y = 1 - (n ./ x) .^ 2;
end
