function lab01
	% Вводим параметры дискретизации
	n = input('Количество точек: ');
	dt = input('Расстояние между точками: ');
	t_max = dt * (n - 1) / 2;

	% Исходный сигнал
	x = -t_max:0.01:t_max;
	gaussian_reference = gaussian(x);
	rectangular_reference = rectangular(x);

	% Дискретизация
	t = -t_max:dt:t_max;
	gaussian_discrete = gaussian(t);
	rectangular_discrete = rectangular(t);

	% Восстанавиваем сигнал
	gaussian_restored = zeros(1, length(x));
	rectangular_restored = zeros(1, length(x));
	for i = 1:length(x)
		for j = 1:n
			tmp = normsinc((x(i) - t(j)) / dt);
			gaussian_restored(i) = gaussian_restored(i) + gaussian_discrete(j) * tmp;
			rectangular_restored(i) = rectangular_restored(i) + rectangular_discrete(j) * tmp;
		end
	end

	figure;
	subplot(2, 1, 1);
	title('Прямоугольный сигнал');
	hold on;
	grid on;
	plot(x, rectangular_reference, 'b');
	plot(x, rectangular_restored, 'k');
	plot(t, rectangular_discrete, '.m');
	legend('Исходный', 'Восстановленный', 'Дискретный');

	subplot(2, 1, 2);
	title('Сигнал Гаусса');
	hold on;
	grid on;
	plot(x, gaussian_reference, 'b');
	plot(x, gaussian_restored, 'k');
	plot(t, gaussian_discrete, '.m');
	legend('Исходный', 'Восстановленный', 'Дискретный');

	print -dpng plot01.png;
end

function [y] = gaussian(x)
	A = 1;
	sigma = 5;

	y = A * exp(-(x / sigma) .^ 2);
end

function [y] = rectangular(x)
	c = 5;

	y = zeros(size(x));
	y(abs(x) < c) = 1;
end

function [y] = normsinc(x)
	if x ~= 0
		y = sin(pi * x) / (pi * x);
	else
		y = 1;
	end
end
