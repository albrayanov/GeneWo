from PIL import Image
import numpy as np
import sys

# Get image array using the command line
def get_image_array(image_path):
    image = Image.open(image_path)
    return np.asarray(image, dtype=np.uint8)

# Filter RGB values so they are DNA encoding compatible

### Div Filter: decides the dna encoding based on whether the sum R,G,B channels mod 4 
def div_filter(pixel_input):
    pixel_color_sum = np.sum(pixel_input)
    filter =  pixel_color_sum % 4
    match filter:
        case 0:
            return ("00", "A", [0,0,255])
        case 1:
            return ("01", "G", [0,255,0])
        case 2:
            return ("10", "C", [255,0,0])
        case 3: 
            return ("11", "T", [255,255,0])

### Sum  Filter: decides the dna encoding based on whether the sum R,G,B channels mod 4           
def sum_filter(pixel_input):
    pixel_color_sum = np.sum(pixel_input)
    if pixel_color_sum <= 192:
        return ("00", "A", [0,0,255])
    elif pixel_color_sum <= 384:
        return ("01", "G", [0,255,0])
    elif pixel_color_sum <= 576:
        return ("10", "C", [255,0,0])
    else: 
        return ("11", "T", [255,255,0])

def sum_div_filter(pixel_input):
    pixel_color_sum = np.sum(pixel_input)
    div = pixel_color_sum % 4
    sum = int(pixel_color_sum / 192)
    filter = (div + sum) % 4 
    match filter:
        case 0:
            return ("00", "A", [0,0,255])
        case 1:
            return ("01", "G", [0,255,0])
        case 2:
            return ("10", "C", [255,0,0])
        case 3: 
            return ("11", "T", [255,255,0])

def div_div_filter(pixel_input):
    pixel_color_sum = np.sum(pixel_input)
    div = pixel_color_sum % 192
    filter = div % 4 
    match filter:
        case 0:
            return ("00", "A", [0,0,255])
        case 1:
            return ("01", "G", [0,255,0])
        case 2:
            return ("10", "C", [255,0,0])
        case 3: 
            return ("11", "T", [255,255,0])



    
def apply_dna_filter(input_array, filter_type=0):
    for x in range(0,input_array.shape[0]): 
        for y in range(0,input_array.shape[1]):
            output = ("XX","F",[0,0,0])
            # add more cases when you add new filters 
            match filter_type:
                case 0:
                    output = div_filter(input_array[x][y])
                case 1:
                    output = sum_filter(input_array[x][y])
                case 2:
                    output = sum_div_filter(input_array[x][y])
                case 3:
                    output = div_div_filter(input_array[x][y])

            output_binary.write(output[0] + ",")
            output_fasta.write(output[1])
            output_image_data[x][y] = output[2]

image_path = sys.argv[1]
filter_type_input = sys.argv[2]
input_image = get_image_array(image_path)
output_binary = open("dna_bin.csv", "a")
output_fasta = open("dna_fasta.fa", "a")
output_image_data = np.zeros(input_image.shape, dtype=np.uint8)
apply_dna_filter(input_image, int(filter_type_input))
image = Image.fromarray(output_image_data,'RGB')
image.save("dna_output-4.png")
image.show()