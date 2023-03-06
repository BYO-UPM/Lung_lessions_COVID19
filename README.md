

# Automatic identification of lung opacities due to COVID-19 from chest X-Ray images. Focussing attention on the lungs

Julián D. Arias-Londoño , Álvaro Moure-Prado, and Juan I. Godino-Llorente 

Submitted to "Diagnostics" 


## Abstract: 
Due to the primary affection of the respiratory system, COVID-19 leaves traces that are visible in plain chest X-Ray images. This is why this imaging technique is typically used in the clinic for an initial evaluation of the patient’s degree of affection. However, individually studying every patient’s radiograph is time-consuming and requires highly skilled personnel. This is why automatic decision support systems capable of identifying those lesions due to COVID-19 are of practical interest, not only for alleviating the workload in the clinic environment, but also for potentially detecting non-evident lung lesions. This article proposes an alternative approach to identify lung lesions associated with COVID-19 from plain chest X-Ray images using deep learning techniques. The novelty of the method is based on an alternative pre-processing of the images that focusses attention on a certain region of interest by cropping the original image to the area of the lungs. The process simplifies training by removing irrelevant information, improving model precision, and making the decision more understandable. Using the FISABIO-RSNA COVID-19 Detection open data set, results report that the opacities due to COVID-19 can be detected with a Mean Average Precision with an IoU > 0.5 (mAP@50) of 0.59 following a semi-supervised training procedure and an ensemble of two architectures: RetinaNet and Cascade R-CNN. The results also suggest that cropping to the rectangular area occupied by the lungs improves the detection of existing lesions. A main methodological conclusion is also presented, suggesting the need of resizing the available bounding boxes used to delineate the opacities. This process removes inaccuracies during the labelling procedure, leading to more accurate results. This procedure can be easily performed automatically after the cropping stage. 


## Intructions for running the code

In order to reproduce the results of the paper the following steps need to be followed.

1. Download the input data from the Kaggle challenge available here: https://www.kaggle.com/competitions/siim-covid19-detection and extract it in the kaggle/input directory

2. 