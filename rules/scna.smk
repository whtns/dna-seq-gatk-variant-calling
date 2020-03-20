## ------------------------------------------------------------------------------------ ##
## CopywriteR
## ------------------------------------------------------------------------------------ ##
## CopywriteR

## Define the R binary
Rbin = config["Rbin"]

def human_readable(bin_size):
  bin_size = bin_size/1000
  bin_size = f'{bin_size}kb'
  print(bin_size)

rule CopywriteR:
	input:
	  sample_files = expand("recal/{u.sample}-{u.unit}.bam",
                u=units.itertuples()),
	  script = "scripts/run_copywriter.R"
	output:
		"copywriter" + "/CNAprofiles/segment.Rdata"
	log:
		"Rout/copywriter.Rout"
	benchmark:
		"benchmarks/copywriter.txt"
	params:
	  bin_size = config["scna"]["bin_size"],
	  copywriter_output_dir = "copywriter",
		threads = config["ncores"],
		samples_pattern = ".bam",
		input_dir = "recal" 
	shell:
		'''{Rbin} CMD BATCH --no-restore --no-save "--args threads='{threads}' copywriter_output_dir='{params.copywriter_output_dir}' bin_size='{params.bin_size}' input_dir='{params.input_dir}' samples_pattern='{params.samples_pattern}'" {input.script} {log}'''