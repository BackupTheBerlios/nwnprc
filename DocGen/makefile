COMPILER = javac
FLAGS = -Xlint:all -g -source 1.5 -target 1.5
TARGET = prc/autodoc/*.java


default:
	$(COMPILER) $(FLAGS) $(TARGET)


run:
	java -Xmx300m -Xms300m prc/autodoc/Main

run_quiet:
	java -Xmx300m -Xms300m prc/autodoc/Main -q

run_no_spinner:
	java -Xmx300m -Xms300m prc/autodoc/Main -s
