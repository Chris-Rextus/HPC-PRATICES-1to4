% Pedro Augusto Faria - 821124
% Arquiteturas de Alto Desempenho - Prof. Emerson

% Prática 01 - Simulação de Monte Carlo

clear; clc;
format long;

n = 50000000;

tic;

% 1. Versão Vetorial

x = 2*rand(n,1) - 1;
y = 2*rand(n,1) - 1;

inside=  (x.^2 + y.^2) <= 1;

pi_vec = 4 * sum(inside) / n;

time_vec = toc;

tic;

% 2. Versão Serial

tic;

count = 0;

for i = 1:n
    x = 2*rand - 1;
    y = 2*rand - 1;

    if (x^2 + y^2) <= 1
        count = count + 1;
    end
end

pi_serial = 4 * count / n;

time_serial = toc;

% 3. Versão Paralela

tic;

count_par = 0;

parfor i = 1:n
    x = 2*rand - 1;
    y = 2*rand - 1;

    if (x^2 + y^2) <= 1
        count_par = count_par + 1;
    end
end

pi_par = 4 * count_par / n;

time_par = toc;

% 4. Cálculo de Erro

pi_true = pi;

error_vec = abs(pi_vec - pi_true);
error_serial = abs(pi_serial - pi_true);
error_par = abs(pi_par - pi_true);

% 5. Speedup

speedup_vec = time_serial / time_vec;
speedup_par = time_serial / time_par;

% 6. Display de Resultados

disp('==============================================')
disp('        MONTE CARLO PI ESTIMATION')
disp('==============================================')

fprintf('\nNumber of points (n): %d\n', n)

disp('----------------------------------------------')
disp('Estimated Values of Pi:')
fprintf('Vectorized  : %.10f\n', pi_vec)
fprintf('Serial      : %.10f\n', pi_serial)
fprintf('Parallel    : %.10f\n', pi_par)
fprintf('MATLAB Pi   : %.10f\n', pi)

disp('----------------------------------------------')
disp('Absolute Errors:')
fprintf('Vectorized  : %.10e\n', error_vec)
fprintf('Serial      : %.10e\n', error_serial)
fprintf('Parallel    : %.10e\n', error_par)

disp('----------------------------------------------')
disp('Execution Times (seconds):')
fprintf('Vectorized  : %.6f s\n', time_vec)
fprintf('Serial      : %.6f s\n', time_serial)
fprintf('Parallel    : %.6f s\n', time_par)

disp('----------------------------------------------')
disp('Speedup (relative to Serial):')
fprintf('Vectorized  : %.2f x faster\n', speedup_vec)
fprintf('Parallel    : %.2f x faster\n', speedup_par)

disp('==============================================')

% ==============================================
% 7. ANÁLISE DE PERFORMANCE vs n
% ==============================================

n_values = [1e3, 5e3, 1e4, 5e4, 1e5, 5e5];

time_vec_arr = zeros(size(n_values));
time_serial_arr = zeros(size(n_values));
time_par_arr = zeros(size(n_values));

for k = 1:length(n_values)
    
    n = n_values(k);
    
    % -------- Vectorized --------
    tic;
    x = 2*rand(n,1) - 1;
    y = 2*rand(n,1) - 1;
    inside = (x.^2 + y.^2) <= 1;
    pi_vec = 4 * sum(inside) / n;
    time_vec_arr(k) = toc;
    
    % -------- Serial --------
    tic;
    count = 0;
    for i = 1:n
        x = 2*rand - 1;
        y = 2*rand - 1;
        if (x^2 + y^2) <= 1
            count = count + 1;
        end
    end
    time_serial_arr(k) = toc;
    
    % -------- Parallel --------
    tic;
    count_par = 0;
    parfor i = 1:n
        x = 2*rand - 1;
        y = 2*rand - 1;
        if (x^2 + y^2) <= 1
            count_par = count_par + 1;
        end
    end
    time_par_arr(k) = toc;
end

figure;

plot(n_values, time_vec_arr, '-o', 'LineWidth', 2);
hold on;
plot(n_values, time_serial_arr, '-s', 'LineWidth', 2);
plot(n_values, time_par_arr, '-^', 'LineWidth', 2);

xlabel('Number of points (n)');
ylabel('Execution Time (seconds)');
title('Performance Comparison');

legend('Vectorized', 'Serial', 'Parallel');
grid on;

speedup_vec_arr = time_serial_arr ./ time_vec_arr;
speedup_par_arr = time_serial_arr ./ time_par_arr;

figure;

plot(n_values, speedup_vec_arr, '-o', 'LineWidth', 2);
hold on;
plot(n_values, speedup_par_arr, '-s', 'LineWidth', 2);

xlabel('Number of points (n)');
ylabel('Speedup');
title('Speedup vs Problem Size');

legend('Vectorized Speedup', 'Parallel Speedup');
grid on;

% FIM







