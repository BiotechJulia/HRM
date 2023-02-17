# HRM
High resolution melting (HRM) data analysis
This script allows for the classification of samples from HRM experiments to separate clusters representing predicted sample types. Prepare your data accordingly to the "sample_data.csv" file - the first column contains subsequent melting temperatures and the next columns contain fluorescence data for the samples. If you are working on the StepOnePlus™ Real-Time PCR System, export the "Melt Region Temperature Data" and "Melt Region Normalized Data" file type: .txt from the StepOnePlus™ Software and use the data conversion.R script first.

Plot the melting curve data to define the temperature range containing the PCR product melting temperature:
![1](https://user-images.githubusercontent.com/125211875/219647498-60423d89-9d47-4f33-89d8-a5d4aa0dfb2f.jpg)
Here, I selected a temperature range between 75 and 90 degrees. If you see any outlier samples, you can remove them too. 
Next, normalize the data:
![3](https://user-images.githubusercontent.com/125211875/219648028-ec7a7663-2067-4df8-a369-3260ce3b5387.jpg)
Calculate the differences between the tested samples and the reference sample:
![4](https://user-images.githubusercontent.com/125211875/219648256-a781b19f-a66d-45c4-9e7e-2153005d7ac8.jpg)
Based on that, assign samples to the clusters and customize your plot to match the publication requirements:
![7](https://user-images.githubusercontent.com/125211875/219651509-c6cec10b-4699-4be3-806b-1ff1d890463b.jpg)

Save the clustering data to identify samples of interest, and of course, confirm the results with sequencing.

The sample data contain the data from the HRM analysis of the single point mutation line, so the differences between the samples are not big. I set the instrument for 0.1 degree difference between every read and used SYBR Green I dye. So far, I have analyzed 2 single point mutation lines like that, and sequencing confirmed the accuracy of the HRM prediction in 100%.
