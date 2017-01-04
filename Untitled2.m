% This report explains Weighted Least Square Estimator for network whose
% data is given with two files namely ieee_cdf.dat and measure.dat

clear all;
close all;
clc;

ieee_data = importdata( 'ieee_cdf.dat');
ieee_data_matrix = ieee_data.data;

fileID = fopen ('measure.dat');
measurementdata = dlmread(fileID);
fclose(fileID);
