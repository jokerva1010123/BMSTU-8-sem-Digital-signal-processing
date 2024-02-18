#!/usr/bin/env python3

from math import exp
from sys import argv
import numpy as np
import matplotlib.pyplot as plt


def gaussian_function(x):
    A: float = 1.0
    sigma: float = 5.0
    return A * exp(-(x / sigma) ** 2)


def boxcar_function(x):
    c: float = 5.0
    return int(abs(x) < c)


def main() -> None:
    vectorized_gaussian_function = np.vectorize(gaussian_function)
    vectorized_boxcar_function = np.vectorize(boxcar_function)

    # Ввод параметров дискретизации
    n = int(input('Количество точек: ')) if len(argv) < 2 else int(argv[1])
    dt = float(input('Расстояние между точками: ')) if len(argv) < 3 else float(argv[2])
    t_max = dt * (n - 1) / 2.0

    # Исходный сигнал
    dx = 0.01
    x = np.arange(-t_max, t_max + dx / 2.0, dx)
    gaussian_reference = vectorized_gaussian_function(x)
    rectangular_reference = vectorized_boxcar_function(x)

    # Дискретизация
    t = np.arange(-t_max, t_max + dt / 2.0, dt)
    gaussian_discrete = vectorized_gaussian_function(t)
    rectangular_discrete = vectorized_boxcar_function(t)

    # Восстановление сигнала
    gaussian_restored = np.zeros(x.size)
    rectangular_restored = np.zeros(x.size)
    for i in range(x.size):
        for j in range(n):
            sinc = np.sinc((x[i] - t[j]) / dt)
            gaussian_restored[i] += gaussian_discrete[j] * sinc
            rectangular_restored[i] += rectangular_discrete[j] * sinc

    fig, axs = plt.subplots(2, 1)
    axs[0].plot(x, rectangular_reference, label='Исходный')
    axs[0].plot(x, rectangular_restored, label='Восстановленный')
    axs[0].scatter(t, rectangular_discrete, label='Дискретный')
    axs[0].set_ylabel('Прямоугольный импульс')
    axs[0].grid(True)
    axs[1].plot(x, gaussian_reference, label='Исходный')
    axs[1].plot(x, gaussian_restored, label='Восстановленный')
    axs[1].scatter(t, gaussian_discrete, label='Дискретный')
    axs[1].set_ylabel('Сигнал Гаусса')
    axs[1].grid(True)

    # fig.tight_layout()
    plt.legend()
    plt.show()


if __name__ == '__main__':
    main()
