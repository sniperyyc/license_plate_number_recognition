import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

from scipy.misc import imsave, imread, imresize
import numpy as np
from keras.models import model_from_yaml
import pickle


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


def predict(img):
    ''' Called when user presses the predict button.
        Processes the canvas and handles the image.
        Passes the loaded image into the neural network and it makes
        class prediction.
    '''

    # read parsed image back in 8-bit, black and white mode (L)
    # x = imread('output.png', mode='L')
    # img = np.invert(img)
    img = imresize(img,(28,28))

    # Fill in to a larger blank image
    # x = np.zeros([56,56],dtype=np.uint8)
    # x[:] = 255
    # x[14:42,14:42] = img
    # x = imresize(x,(28,28))

    # Visualize new array
    x = img
    imsave('resized.png', x)

    # reshape image data for use in neural network
    x = x.reshape(1,28,28,1)

    # Convert type to float32
    x = x.astype('float32')

    # Normalize to prevent issues with model
    x /= 255

    # Predict from model
    out = model.predict(x)
    return out



if __name__ == '__main__':
    model = load_model("bin")
    mapping = pickle.load(open('bin/mapping.p', 'rb'))

    test_dir = 'test_digits/'
    for img in os.listdir(test_dir):
        if img == ".DS_Store":
            continue
        img = imread(test_dir + img, mode='L')
        out = predict(img)
        y = chr(mapping[(int(np.argmax(out, axis=1)[0]))])
        print(y)



