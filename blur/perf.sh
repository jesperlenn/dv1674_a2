#!/usr/bin/env bash


# --- kernel size 100 ---
perf stat ./blur 100 data/im1.ppm data_o/im1_blurred.ppm 2> ../blurred_baseline/100/im1.perf
perf stat ./blur 100 data/im2.ppm data_o/im2_blurred.ppm 2> ../blurred_baseline/100/im2.perf
perf stat ./blur 100 data/im3.ppm data_o/im3_blurred.ppm 2> ../blurred_baseline/100/im3.perf
perf stat ./blur 100 data/im4.ppm data_o/im4_blurred.ppm 2> ../blurred_baseline/100/im4.perf

# --- kernel size 200 ---
perf stat ./blur 200 data/im1.ppm data_o/im1_blurred.ppm 2> ../blurred_baseline/200/im1.perf
perf stat ./blur 200 data/im2.ppm data_o/im2_blurred.ppm 2> ../blurred_baseline/200/im2.perf
perf stat ./blur 200 data/im3.ppm data_o/im3_blurred.ppm 2> ../blurred_baseline/200/im3.perf
perf stat ./blur 200 data/im4.ppm data_o/im4_blurred.ppm 2> ../blurred_baseline/200/im4.perf

# --- kernel size 300 ---
perf stat ./blur 300 data/im1.ppm data_o/im1_blurred.ppm 2> ../blurred_baseline/300/im1.perf
perf stat ./blur 300 data/im2.ppm data_o/im2_blurred.ppm 2> ../blurred_baseline/300/im2.perf
perf stat ./blur 300 data/im3.ppm data_o/im3_blurred.ppm 2> ../blurred_baseline/300/im3.perf
perf stat ./blur 300 data/im4.ppm data_o/im4_blurred.ppm 2> ../blurred_baseline/300/im4.perf

# --- kernel size 400 ---
perf stat ./blur 400 data/im1.ppm data_o/im1_blurred.ppm 2> ../blurred_baseline/400/im1.perf
perf stat ./blur 400 data/im2.ppm data_o/im2_blurred.ppm 2> ../blurred_baseline/400/im2.perf
perf stat ./blur 400 data/im3.ppm data_o/im3_blurred.ppm 2> ../blurred_baseline/400/im3.perf
perf stat ./blur 400 data/im4.ppm data_o/im4_blurred.ppm 2> ../blurred_baseline/400/im4.perf

# --- kernel size 500 ---
perf stat ./blur 500 data/im1.ppm data_o/im1_blurred.ppm 2> ../blurred_baseline/500/im1.perf
perf stat ./blur 500 data/im2.ppm data_o/im2_blurred.ppm 2> ../blurred_baseline/500/im2.perf
perf stat ./blur 500 data/im3.ppm data_o/im3_blurred.ppm 2> ../blurred_baseline/500/im3.perf
perf stat ./blur 500 data/im4.ppm data_o/im4_blurred.ppm 2> ../blurred_baseline/500/im4.perf

# --- kernel size 600 ---
perf stat ./blur 600 data/im1.ppm data_o/im1_blurred.ppm 2> ../blurred_baseline/600/im1.perf
perf stat ./blur 600 data/im2.ppm data_o/im2_blurred.ppm 2> ../blurred_baseline/600/im2.perf
perf stat ./blur 600 data/im3.ppm data_o/im3_blurred.ppm 2> ../blurred_baseline/600/im3.perf
perf stat ./blur 600 data/im4.ppm data_o/im4_blurred.ppm 2> ../blurred_baseline/600/im4.perf

# --- kernel size 700 ---
perf stat ./blur 700 data/im1.ppm data_o/im1_blurred.ppm 2> ../blurred_baseline/700/im1.perf
perf stat ./blur 700 data/im2.ppm data_o/im2_blurred.ppm 2> ../blurred_baseline/700/im2.perf
perf stat ./blur 700 data/im3.ppm data_o/im3_blurred.ppm 2> ../blurred_baseline/700/im3.perf
perf stat ./blur 700 data/im4.ppm data_o/im4_blurred.ppm 2> ../blurred_baseline/700/im4.perf

# --- kernel size 800 ---
perf stat ./blur 800 data/im1.ppm data_o/im1_blurred.ppm 2> ../blurred_baseline/800/im1.perf
perf stat ./blur 800 data/im2.ppm data_o/im2_blurred.ppm 2> ../blurred_baseline/800/im2.perf
perf stat ./blur 800 data/im3.ppm data_o/im3_blurred.ppm 2> ../blurred_baseline/800/im3.perf
perf stat ./blur 800 data/im4.ppm data_o/im4_blurred.ppm 2> ../blurred_baseline/800/im4.perf

# --- kernel size 900 ---
perf stat ./blur 900 data/im1.ppm data_o/im1_blurred.ppm 2> ../blurred_baseline/900/im1.perf
perf stat ./blur 900 data/im2.ppm data_o/im2_blurred.ppm 2> ../blurred_baseline/900/im2.perf
perf stat ./blur 900 data/im3.ppm data_o/im3_blurred.ppm 2> ../blurred_baseline/900/im3.perf
perf stat ./blur 900 data/im4.ppm data_o/im4_blurred.ppm 2> ../blurred_baseline/900/im4.perf

# --- kernel size 1000 ---
perf stat ./blur 1000 data/im1.ppm data_o/im1_blurred.ppm 2> ../blurred_baseline/1000/im1.perf
perf stat ./blur 1000 data/im2.ppm data_o/im2_blurred.ppm 2> ../blurred_baseline/1000/im2.perf
perf stat ./blur 1000 data/im3.ppm data_o/im3_blurred.ppm 2> ../blurred_baseline/1000/im3.perf
perf stat ./blur 1000 data/im4.ppm data_o/im4_blurred.ppm 2> ../blurred_baseline/1000/im4.perf
