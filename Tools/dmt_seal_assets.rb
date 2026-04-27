#!/usr/bin/env ruby
require "json"
require "fileutils"
require "pathname"

script_root = Pathname.new(__dir__)
project_root = script_root.join("../DoinDiSieied/DMTMealNest").realpath
assets_root = project_root.join("Assets.xcassets")
pantry_root = project_root.join("DMTHearthKit/DMTPlateArt/DMTCipherPantry")
catalog_path = pantry_root.join("dmt_artindex.dat")
skip_assets = ["AppIcon", "AccentColor", "launghcknoieu"].freeze
purge_source = ARGV.include?("--purge-source")

meal_spice = [
  0x44, 0x69, 0x6D, 0x65, 0x65, 0x74, 0x2D, 0x46,
  0x6C, 0x61, 0x76, 0x6F, 0x72, 0x2D, 0x43, 0x68
].freeze

def dmt_cipher(bytes, spice)
  bytes.each_with_index.map do |byte, index|
    swirl = ((index * 29) + 113) & 0xFF
    byte ^ (spice[index % spice.length] ^ swirl)
  end.pack("C*")
end

def highest_scale_entry(imageset_path)
  contents_path = imageset_path.join("Contents.json")
  return nil unless contents_path.exist?

  payload = JSON.parse(contents_path.read)
  entries = payload.fetch("images", []).filter_map do |entry|
    next unless entry["filename"]
    scale_text = entry["scale"].to_s.delete_suffix("x")
    scale_value = scale_text.empty? ? 1.0 : scale_text.to_f
    entry.merge("scale_value" => scale_value)
  end

  entries.max_by { |entry| entry["scale_value"] }
end

def next_course_name(catalog)
  used = catalog.values
    .filter_map { |entry| entry["file"] }
    .map { |file| file[/\d+\z/].to_i }
  format("dmt_course_%03d", used.max.to_i + 1)
end

abort("missing assets catalog: #{assets_root}") unless assets_root.exist?
abort("missing pantry folder: #{pantry_root}") unless pantry_root.exist?
abort("missing art index: #{catalog_path}") unless catalog_path.exist?

catalog = JSON.parse(dmt_cipher(catalog_path.binread.bytes, meal_spice))
sealed_count = 0
purged_count = 0

assets_root.children.sort.each do |entry|
  next unless entry.directory?
  next unless entry.extname == ".imageset"

  asset_name = entry.basename(".imageset").to_s
  next if skip_assets.include?(asset_name)

  chosen_entry = highest_scale_entry(entry)
  next unless chosen_entry

  if catalog.key?(asset_name)
    if purge_source
      FileUtils.rm_rf(entry)
      purged_count += 1
    end
    next
  end

  source_path = entry.join(chosen_entry.fetch("filename"))
  next unless source_path.exist?

  course_name = next_course_name(catalog)
  sealed_path = pantry_root.join("#{course_name}.dat")
  sealed_blob = dmt_cipher(source_path.binread.bytes, meal_spice)
  sealed_path.binwrite(sealed_blob)

  catalog[asset_name] = {
    "file" => course_name,
    "scale" => chosen_entry.fetch("scale_value")
  }
  sealed_count += 1

  if purge_source
    FileUtils.rm_rf(entry)
    purged_count += 1
  end
end

catalog_path.binwrite(dmt_cipher(JSON.pretty_generate(catalog).bytes, meal_spice))
puts "sealed=#{sealed_count} purged=#{purged_count}"
