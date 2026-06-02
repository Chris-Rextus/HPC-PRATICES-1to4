# ============================================================
# Pedro Augusto Faria - 821124
# High Performance Architectures
# Python Benchmark: Monte Carlo + Leibniz
# ============================================================

import numpy as np
import time
import math
import multiprocessing as mp
import matplotlib.pyplot as plt

# ============================================================
# CONFIG
# ============================================================

N_MONTE = int(5e6)     
N_LEIBNIZ = int(5e5)

N_VALUES = [int(x) for x in [1e3, 5e3, 1e4, 5e4, 1e5, 5e5]]

# ============================================================
# MONTE CARLO 
# ============================================================

def monte_carlo_vectorized(n):
    x = np.random.uniform(-1, 1, n)
    y = np.random.uniform(-1, 1, n)
    inside = (x**2 + y**2) <= 1
    return 4 * np.sum(inside) / n

def monte_carlo_serial(n):
    count = 0
    for _ in range(n):
        x = np.random.uniform(-1, 1)
        y = np.random.uniform(-1, 1)
        if x*x + y*y <= 1:
            count += 1
    return 4 * count / n

def mc_worker(n):
    x = np.random.uniform(-1, 1, n)
    y = np.random.uniform(-1, 1, n)
    return np.sum((x**2 + y**2) <= 1)

def monte_carlo_parallel(n):
    p = mp.cpu_count()
    chunk = n // p
    with mp.Pool(p) as pool:
        results = pool.map(mc_worker, [chunk]*p)
    return 4 * sum(results) / (chunk * p)

# ============================================================
# LEIBNIZ 
# ============================================================

def leibniz_vectorized(n):
    k = np.arange(n)
    return 4 * np.sum((-1)**k / (2*k + 1))

def leibniz_serial(n):
    s = 0.0
    for k in range(n):
        s += ((-1)**k) / (2*k + 1)
    return 4 * s

def leibniz_worker(chunk):
    start, end = chunk
    s = 0.0
    for k in range(start, end):
        s += ((-1)**k) / (2*k + 1)
    return s

def leibniz_parallel(n):
    p = mp.cpu_count()
    chunk_size = n // p
    chunks = [(i*chunk_size, (i+1)*chunk_size) for i in range(p)]

    with mp.Pool(p) as pool:
        results = pool.map(leibniz_worker, chunks)

    return 4 * sum(results)

# ============================================================
# BENCHMARK FUNCTION
# ============================================================

def benchmark(method_name, vec_fn, ser_fn, par_fn, n):

    print("\n" + "="*50)
    print(f"        {method_name.upper()} PI ESTIMATION")
    print("="*50)

    # -------- Vectorized --------
    t0 = time.time()
    pi_vec = vec_fn(n)
    t_vec = time.time() - t0

    # -------- Serial --------
    t0 = time.time()
    pi_ser = ser_fn(n)
    t_ser = time.time() - t0

    # -------- Parallel --------
    t0 = time.time()
    pi_par = par_fn(n)
    t_par = time.time() - t0

    # -------- Errors --------
    pi_true = math.pi
    err_vec = abs(pi_vec - pi_true)
    err_ser = abs(pi_ser - pi_true)
    err_par = abs(pi_par - pi_true)

    # -------- Speedup --------
    speed_vec = t_ser / t_vec
    speed_par = t_ser / t_par

    # -------- Display --------
    print(f"\nNumber of samples (n): {n}")

    print("\nEstimated Pi:")
    print(f"Vectorized  : {pi_vec:.10f}")
    print(f"Serial      : {pi_ser:.10f}")
    print(f"Parallel    : {pi_par:.10f}")
    print(f"Reference   : {pi_true:.10f}")

    print("\nAbsolute Errors:")
    print(f"Vectorized  : {err_vec:.2e}")
    print(f"Serial      : {err_ser:.2e}")
    print(f"Parallel    : {err_par:.2e}")

    print("\nExecution Time (s):")
    print(f"Vectorized  : {t_vec:.6f}")
    print(f"Serial      : {t_ser:.6f}")
    print(f"Parallel    : {t_par:.6f}")

    print("\nSpeedup (vs Serial):")
    print(f"Vectorized  : {speed_vec:.2f}x")
    print(f"Parallel    : {speed_par:.2f}x")

    print("="*50)

    return t_vec, t_ser, t_par


# ============================================================
# PERFORMANCE ANALYSIS
# ============================================================

def performance_analysis(vec_fn, ser_fn, par_fn, n_values, title):

    t_vec_arr = []
    t_ser_arr = []
    t_par_arr = []

    for n in n_values:
        print(f"Running n = {n} ...")

        t0 = time.time()
        vec_fn(n)
        t_vec_arr.append(time.time() - t0)

        t0 = time.time()
        ser_fn(n)
        t_ser_arr.append(time.time() - t0)

        t0 = time.time()
        par_fn(n)
        t_par_arr.append(time.time() - t0)

    # -------- Plot Time --------
    plt.figure()
    plt.plot(n_values, t_vec_arr, marker='o')
    plt.plot(n_values, t_ser_arr, marker='s')
    plt.plot(n_values, t_par_arr, marker='^')

    plt.xlabel("n")
    plt.ylabel("Time (s)")
    plt.title(f"{title} - Execution Time")
    plt.legend(["Vectorized", "Serial", "Parallel"])
    plt.grid()

    # -------- Plot Speedup --------
    speed_vec = np.array(t_ser_arr) / np.array(t_vec_arr)
    speed_par = np.array(t_ser_arr) / np.array(t_par_arr)

    plt.figure()
    plt.plot(n_values, speed_vec, marker='o')
    plt.plot(n_values, speed_par, marker='s')

    plt.xlabel("n")
    plt.ylabel("Speedup")
    plt.title(f"{title} - Speedup")
    plt.legend(["Vectorized", "Parallel"])
    plt.grid()

    plt.show()


# ============================================================
# MAIN
# ============================================================

if __name__ == "__main__":

    # -------- Monte Carlo --------
    benchmark(
        "Monte Carlo",
        monte_carlo_vectorized,
        monte_carlo_serial,
        monte_carlo_parallel,
        N_MONTE
    )

    performance_analysis(
        monte_carlo_vectorized,
        monte_carlo_serial,
        monte_carlo_parallel,
        N_VALUES,
        "Monte Carlo"
    )

    # -------- Leibniz --------
    benchmark(
        "Leibniz",
        leibniz_vectorized,
        leibniz_serial,
        leibniz_parallel,
        N_LEIBNIZ
    )

    performance_analysis(
        leibniz_vectorized,
        leibniz_serial,
        leibniz_parallel,
        N_VALUES,
        "Leibniz"
    )