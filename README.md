# Recession_Timer
This is an algorithm written in MATLAB designed to predict recessions in the United States of America.

License: GNU General Public License v3.0

Quandl and urlread2 are property of their respectful copyright owners.

### Disclaimer
None of the information within this program can legally constitute a recommendation to buy or sell any security, nor be a substitute for professional investment advice. Acting on this information on your own account(s) may result in loss.

## Installation
Download the m file into a directory of your choice. If the directory isn't already on MATLAB's search path, then add the directory by going into file >> Set Path... within the home tab of MATLAB. 

### Dependencies
This requires Quandl's MATLAB package ([here](https://github.com/quandl/Matlab)) and urlread2 ([here](https://www.mathworks.com/matlabcentral/fileexchange/35693-urlread2)) if you do not have them already. Follow the instructions on their respective README's for more details.

## Usage
This app requires you to have a Quandl API in order to extract data from Quandl. Quandl API's are free to everyone who signs up for a Quandl account (as of the time this was typed).

Once you have a Quandl API key, run the file in the MATLAB environment. You will be prompted to enter your Quandl key. After doing so, the program will load in data and after post-processing, will result in an indicator graph displaying 0 for if there is no recession for a given time, or 1 for if there is a recession.
