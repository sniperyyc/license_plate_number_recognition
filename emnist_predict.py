import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

from scipy.misc import imsave, imread, imresize
import numpy as np
from keras.models import model_from_yaml


def load_model(bin_dir):
    ''' Load model from .yaml and the weights from .h5
        Arguments:
            bin_dir: The directory of the bin (normally bin/)
        Returns:
            Loaded model from file
    '''

    # load YAML and create model
    yaml_file = open('%s/model.yaml' % bin_dir, 'r')
    loaded_model_yaml = yaml_file.read()
    yaml_file.close()
    model = model_from_yaml(loaded_model_yaml)

    # load weights into new model
    model.load_weights('%s/model.h5' % bin_dir)
    return model


def predict(x):
    ''' Called when user presses the predict button.
        Processes the canvas and handles the image.
        Passes the loaded image into the neural network and it makes
        class prediction.
    '''

    # read parsed image back in 8-bit, black and white mode (L)
    # x = imread('output.png', mode='L')
    x = np.invert(x)

    # Visualize new array
    imsave('resized.png', x)
    x = imresize(x,(28,28))

    # reshape image data for use in neural network
    x = x.reshape(1,28,28,1)

    # Convert type to float32
    x = x.astype('float32')

    # Normalize to prevent issues with model
    x /= 255

    # Predict from model
    out = model.predict(x)



if __name__ == '__main__':
    model = load_model("bin")
    test_dir = 'dataset_extracted_plate/'
    for x in os.listdir(test_dir):
        x = imread(test_dir + x, mode='L')
        y = predict(x)
        print(y)



