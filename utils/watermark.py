import argparse
from PIL import Image, ImageDraw, ImageFont

def add_oblique_watermark(input_image_path, output_image_path, watermark_text, font_size=100, font_color=(255, 255, 255, 50), angle=30):
    # Open the original image
    image = Image.open(input_image_path).convert("RGBA")

    # Create a new transparent layer for the text with the same size as the image
    txt_layer = Image.new("RGBA", image.size, (255, 255, 255, 0))

    # Load a font, if you have a TTF font file, you can specify its path
    try:
        font = ImageFont.truetype("arial.ttf", font_size)
    except IOError:
        # Fallback to a default font if the specified font is not available
        font = ImageFont.load_default()

    draw = ImageDraw.Draw(txt_layer)

    # Calculate the size of the text
    text_bbox = draw.textbbox((0, 0), watermark_text, font=font)
    text_width = text_bbox[2] - text_bbox[0]
    text_height = text_bbox[3] - text_bbox[1]

    # Draw the text multiple times across the image
    for y in range(0, image.size[1] + text_height, text_height + 50):
        for x in range(0, image.size[0] + text_width, text_width + 50):
            position = (x, y)
            draw.text(position, watermark_text, font=font, fill=font_color)

    # Composite the text layer onto the original image
    watermarked_image = Image.alpha_composite(image, txt_layer)

    # Save the final image
    watermarked_image.save(output_image_path, "PNG")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Add watermark to an image')
    parser.add_argument('input_image_path', help='Path to your input PNG image')
    parser.add_argument('output_image_path', help='Path to save the output PNG image')
    parser.add_argument('watermark_text', help='The word to be drawn as watermark')

    args = parser.parse_args()

    input_image_path = args.input_image_path
    output_image_path = args.output_image_path
    watermark_text = args.watermark_text
    font_size = 200  # Size of the watermark text
    font_color = (255, 255, 255, 50)  # Light gray color with low opacity
    angle = 30  # Angle at which the text will be drawn
    add_oblique_watermark(input_image_path, output_image_path, watermark_text, font_size, font_color, angle)

