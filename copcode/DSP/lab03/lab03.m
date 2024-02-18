function lab03
	% Входные параметры
	c = 2.0;
	sigma = 1.0;

	% ОДЗ
	t_max = 5;
	dt = 0.05;
	t = -t_max:dt:t_max;

	% Генерация сигналов
	x1 = [rectangular(t, c) zeros(1, length(t))];
	x2 = [gaussian(t, sigma) zeros(1, length(t))];
	x3 = [rectangular(t, c/2) zeros(1, length(t))];
	x4 = [gaussian(t, sigma/2) zeros(1, length(t))];

	% Свертка
	% Фурье-образ взаимной свертки равен произведению Фурье-образов свертываемых функций.
	y1 = ifft(fft(x1) .* fft(x2)) * dt;
	y2 = ifft(fft(x1) .* fft(x3)) * dt;
	y3 = ifft(fft(x2) .* fft(x4)) * dt;

	% Нормализация свёртки
	start = fix((length(y1) - length(t)) / 2);
	y1 = y1(start+1:start+length(t));
	y2 = y2(start+1:start+length(t));
	y3 = y3(start+1:start+length(t));

	graph_figure(1, t, x1, x2, y1, 'П + Г');
	graph_figure(2, t, x1, x3, y2, 'П + П');
	graph_figure(3, t, x2, x4, y3, 'Г + Г');
end

function graph_figure(i, t, x1, x2, y, tit)
	figure(i);
	plot(t, x1(1:201), t, x2(1:201), t, y);
	title(['Свёртка ', tit]);
	legend('Сигнал 1', 'Сигнал 2', 'Свёртка');
	print(strcat('plot03_', num2str(i)), '-dpng');
end

% Rectangular pulse generation
function y = rectangular(x, c)
	y = zeros(size(x));
	y(abs(x) - c < 0) = 1;
	y(abs(x) == c) = 1/2;
end

% Gaussian pulse generation
function y = gaussian(x, sigma)
	y = exp(-(x / sigma) .^ 2);
end
