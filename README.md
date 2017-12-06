license_plate_number_recognition
==============================
### EECS442 Fall 2017, Final Project

### Group name: Lamborghini

### Members:
- Yucheng Yin: Plate Localization and extraction
- Jingyao Hu: Character segmentation
- Jiongsheng Cai: Chracter recognition by CNN

### Introduction to the project:
- Implement a license plate recognition system
- Plate localization by edge detection and color histogram
- Character segmentation by block detection
- Character recognition by CNN

### Running
- Run `crop_segment_image.m` to get cropped plate and segmented digits
- Run `emnist_predict.py` to get predicted results. The result is in test_results.txt. The format is filename, predicted plate.

### Description to the files and folders
#### .m files
- **crop_segment_image.m**: Main file, crop and segment original image.m
- **edge_detect.m**: perform edge detection
- **extract_plate.m**: extract plate by performing histogram
- **remove_shade.m**: remove shade from the region of interest
- **segment.m**: segment the extracted plate

#### .py files
- **emnist_predict.py**: predict characters using stored parameters
- **emnist_train.py**: train CNNs using EMNIST dataset

#### folders
- **baza_slika**: original dataset downloaded
- **bin**: stored CNN parameters
- **dataset**: rearranged dataset
- **dataset_edge**: dataset after edge detection
- **dataset_extracted_digits**: dataset after segmentation
- **dataset_extracted_plate**: dataset after extraction
- **Related work**: Reference papers
- **report**: LATEX project report
- **test_digits**: used for CNN testing



