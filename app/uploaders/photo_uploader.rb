# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

	# Include RMagick or MiniMagick support:
	include CarrierWave::RMagick
	# include CarrierWave::MiniMagick

	# Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
	# include Sprockets::Helpers::RailsHelper
	# include Sprockets::Helpers::IsolatedHelper

	# Choose what kind of storage to use for this uploader:
	# storage :file
	storage :fog

	# Override the directory where uploaded files will be stored.
	# This is a sensible default for uploaders that are meant to be mounted:
	def store_dir
		"#{model.class.to_s.underscore}"
	end

	# Provide a default URL as a default if there hasn't been a file uploaded:
	# def default_url
	#  # For Rails 3.1+ asset pipeline compatibility:
	#  # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
	#
	#  "/images/fallback/" + [version_name, "default.png"].compact.join('_')
	# end

	# Process files as they are uploaded:
	# process :scale => [200, 300]
	#
	# def scale(width, height)
	#  # do something
	# end

	version :big do
		process resize_to_limit: [1000, 600]
		process :watermark
	end

	version :small do
		resize_to_fit 220, 200
		# process :watermark
	end

	
	def watermark
		if model.watermark
			manipulate! do |img|
				watermark = Magick::Image.read(Rails.root.join "app", "assets", "images", "made-with-svarovski-elements.png").first
				img.composite watermark, Magick::SouthEastGravity, Magick::OverCompositeOp
			end
		end
	end

	# Add a white list of extensions which are allowed to be uploaded.
	# For images you might use something like this:
	# def extension_white_list
	#  %w(jpg jpeg gif png)
	# end

	# Override the filename of the uploaded files:
	# Avoid using model.id or version_name here, see uploader/store.rb for details.
	# def filename
	#  "something.jpg" if original_filename
	# end

end
