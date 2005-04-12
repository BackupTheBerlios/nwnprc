COMPILER = javac
FLAGS = -Xlint:all -g -source 1.5 -target 1.5
RUNPARAMS = -Xmx300m -Xms300m -cp imageio_tga_1.1.0.jar\;
TARGET = prc/autodoc/*.java


default:
	$(COMPILER) $(FLAGS) $(TARGET)


run:
	java $(RUNPARAMS) prc/autodoc/Main

run_quiet:
	java $(RUNPARAMS) prc/autodoc/Main -q

run_no_spinner:
	java $(RUNPARAMS) prc/autodoc/Main -s

run_log:
	java $(RUNPARAMS) prc/autodoc/Main -s > log.txt

run_icons:
	java $(RUNPARAMS) prc/autodoc/Main -i

run_icons_log:
	java $(RUNPARAMS) prc/autodoc/Main -is > log.txt