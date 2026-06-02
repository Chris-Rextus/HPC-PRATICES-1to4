% Pedro Augusto Faria - 821124
% Arquiteturas de Alto Desempenho - Prof. Emerson

% Prática 02 - Série de Leibniz para cálculo de Pi

clear; clc;
format long;

n = 50000000;

% ==============================================
% 1. VERSÃO VETORIZADA
% ==============================================

tic;

k = (0:n-1)';
terms = (-1).^k ./ (2*k + 1);
pi_vec = 4 * sum(terms);

time_vec = toc;

% ==============================================
% 2. VERSÃO SERIAL
% ==============================================

tic;

sum_serial = 0;

for k = 0:n-1
    sum_serial = sum_serial + ((-1)^k)/(2*k + 1);
end

pi_serial = 4 * sum_serial;

time_serial = toc;

% ==============================================
% 3. VERSÃO PARALELA
% ==============================================


tic;

sum_par = 0;

parfor k = 0:n-1
    sum_par = sum_par + ((-1)^k)/(2*k + 1);
end

pi_par = 4 * sum_par;

time_par = toc;

% ==============================================
% 4. CÁLCULO DE ERRO
% ==============================================

pi_true = pi;

error_vec = abs(pi_vec - pi_true);
error_serial = abs(pi_serial - pi_true);
error_par = abs(pi_par - pi_true);

% ==============================================
% 5. SPEEDUP
% ==============================================

speedup_vec = time_serial / time_vec;
speedup_par = time_serial / time_par;

% ==============================================
% 6. DISPLAY DE RESULTADOS
% ==============================================

disp('==============================================')
disp('        LEIBNIZ PI ESTIMATION')
disp('==============================================')

fprintf('\nNumber of terms (n): %d\n', n)

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

for idx = 1:length(n_values)
    
    n = n_values(idx);
    
    % -------- Vectorized --------
    tic;
    k = (0:n-1)';
    terms = (-1).^k ./ (2*k + 1);
    pi_vec = 4 * sum(terms);
    time_vec_arr(idx) = toc;
    
    % -------- Serial --------
    tic;
    sum_serial = 0;
    for k = 0:n-1
        sum_serial = sum_serial + ((-1)^k)/(2*k + 1);
    end
    time_serial_arr(idx) = toc;
    
    % -------- Parallel --------
    tic;
    sum_par = 0;
    parfor k = 0:n-1
        sum_par = sum_par + ((-1)^k)/(2*k + 1);
    end
    time_par_arr(idx) = toc;
end

% ==============================================
% 8. PLOT - TEMPO DE EXECUÇÃO
% ==============================================

figure;

plot(n_values, time_vec_arr, '-o', 'LineWidth', 2);
hold on;
plot(n_values, time_serial_arr, '-s', 'LineWidth', 2);
plot(n_values, time_par_arr, '-^', 'LineWidth', 2);

xlabel('Number of terms (n)');
ylabel('Execution Time (seconds)');
title('Leibniz Performance Comparison');

legend('Vectorized', 'Serial', 'Parallel');
grid on;

% ==============================================
% 9. PLOT - SPEEDUP
% ==============================================

speedup_vec_arr = time_serial_arr ./ time_vec_arr;
speedup_par_arr = time_serial_arr ./ time_par_arr;

figure;

plot(n_values, speedup_vec_arr, '-o', 'LineWidth', 2);
hold on;
plot(n_values, speedup_par_arr, '-s', 'LineWidth', 2);

xlabel('Number of terms (n)');
ylabel('Speedup');
title('Leibniz Speedup vs Problem Size');

legend('Vectorized Speedup', 'Parallel Speedup');
grid on;

% FIM











