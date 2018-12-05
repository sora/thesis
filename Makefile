BUILD_DIR = ./build
SRC_DIR = ./src
SRCS = $(shell ls $(SRC_DIR)/*.tex)

MAIN_TEX = $(SRC_DIR)/thesis.tex
MAIN_PDF = $(MAIN_TEX:$(SRC_DIR)/%.tex=$(BUILD_DIR)/%.pdf)

REDPEN := $(if $(REDPEN),$(REDPEN),redpen)

.PHONY: build
build: $(MAIN_PDF)

.PHONY: $(MAIN_PDF)
$(MAIN_PDF): $(BUILD_DIR)/$(SRC_DIR)
	latexmk -pdfdvi $(PREVIEW_CONTINUOUSLY) -use-make $(MAIN_TEX)

# build/src ディレクトリがないとビルドに失敗する
$(BUILD_DIR)/$(SRC_DIR):
	mkdir -p $@

.PHONY: watch
watch: PREVIEW_CONTINUOUSLY=-pvc
watch: build

.PHONY: redpen
redpen: $(SRCS)
	$(REDPEN) $^ --conf redpen-conf.xml --result-format xml > build/redpen.xml

.PHONY: clean
clean:
	@$(RM) -rf $(BUILD_DIR)/*
