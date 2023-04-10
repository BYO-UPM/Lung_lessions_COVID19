

# Automatic identification of lung opacities due to COVID-19 from chest X-Ray images. Focussing attention on the lungs

Julián D. Arias-Londoño , Álvaro Moure-Prado, and Juan I. Godino-Llorente 

Diagnostics 2023, Volume 13, Issue 8, 1381


## Abstract: 
Due to the primary affection of the respiratory system, COVID-19 leaves traces that are visible in plain chest X-Ray images. This is why this imaging technique is typically used in the clinic for an initial evaluation of the patient’s degree of affection. However, individually studying every patient’s radiograph is time-consuming and requires highly skilled personnel. This is why automatic decision support systems capable of identifying those lesions due to COVID-19 are of practical interest, not only for alleviating the workload in the clinic environment, but also for potentially detecting non-evident lung lesions. This article proposes an alternative approach to identify lung lesions associated with COVID-19 from plain chest X-Ray images using deep learning techniques. The novelty of the method is based on an alternative pre-processing of the images that focusses attention on a certain region of interest by cropping the original image to the area of the lungs. The process simplifies training by removing irrelevant information, improving model precision, and making the decision more understandable. Using the FISABIO-RSNA COVID-19 Detection open data set, results report that the opacities due to COVID-19 can be detected with a Mean Average Precision with an IoU > 0.5 (mAP@50) of 0.59 following a semi-supervised training procedure and an ensemble of two architectures: RetinaNet and Cascade R-CNN. The results also suggest that cropping to the rectangular area occupied by the lungs improves the detection of existing lesions. A main methodological conclusion is also presented, suggesting the need of resizing the available bounding boxes used to delineate the opacities. This process removes inaccuracies during the labelling procedure, leading to more accurate results. This procedure can be easily performed automatically after the cropping stage. 


# Code
This code uses a variaty of frameworks and languages. Most of the code is writen in Python except for some MatLab scripts which perform bounding box preprocessing. Deep learning models are implemented using Pytorch and making use of the YoloV5 repository (https://github.com/ultralytics/yolov5) and MMDetection (https://github.com/open-mmlab/mmdetection). The code to download and install these libreraries is provided as the head of most notebooks although it is only required to run it once.

## Intructions for running the code


In order to reproduce the results of the paper the following steps need to be followed.

1. Download the input data from the Kaggle challenge available here: https://www.kaggle.com/competitions/siim-covid19-detection and extract it in the kaggle/input directory

2. Run the dataset_preprocessing.ipynb notebook in order to generate the PNG files from the DICOM and create the resized bounding boxes annotations. Different output sizes can be configured. By default sizes 256x256 512x512 & 768x768 are created.

3. Use the Bboxes.m MATLAB script in order to preprocess the bounding boxes as indicated in Section 2 of the original paper

3. Train the models using the notebooks in the model_training folder

4. Perform inference using the scripts in the inference folder or design your own validation scripts. Paths pointing to the best weights .pth files need to be manually set up by the user.
 

## Hardware

This code was originally designed to be runned in the Kaggle online framework, which has the following specs:

- Tesla P100 16GB RAM GPU
- 16 GB RAM 2vCPUs

The code was also runned and tested in a local enviroment using

- NVIDIA RTX2080 GPU
- 32GB RAM
