alexandria = git://common-lisp.net/projects/alexandria/alexandria.git
babel = https://github.com/cl-babel/babel.git
cffi = https://github.com/cffi/cffi.git
cl_store = https://github.com/skypher/cl-store.git
cl_utilities = https://github.com/Publitechs/cl-utilities.git
fiveam = https://github.com/sionescu/fiveam.git
gsd = http://repo.or.cz/gsd.git
gsll = git://repo.or.cz/gsll.git
lisp_unit = https://github.com/OdonataResearchLLC/lisp-unit.git
split_sequence = https://github.com/sharplispers/split-sequence.git
trivial_features = https://github.com/trivial-features/trivial-features.git
trivial_garbage = https://github.com/trivial-garbage/trivial-garbage.git
trivial_gray_stream = https://github.com/trivial-gray-streams/trivial-gray-streams.git
yason = https://github.com/hanshuebner/yason.git

usage:
		@echo "Usage: make update PKG=<pkgname>"
		@echo "================================"
		@echo "<pkgname> may be one of: alexandria babel cffi cl_store cl_utilities fiveam gsd"
		@echo "                         gsll lisp_unit split_sequence trivial_features"
		@echo "                         trivial_garbage trivial_gray_stream yason"

update:
		@rm -r ./$(PKG)/src
		@echo "Cloning repository $($(PKG))..."
		@git clone $($(PKG)) ./$(PKG)/src
		$(eval GIT_VERSION := $(shell cd ./$(PKG)/src; git rev-parse HEAD))
		@echo "Updating version hash..."
		@sed -i '/<!--external-version>.*<\/external-version-->/ s/>.*</>$(GIT_VERSION)</g' ./$(PKG)/package.xml
		@rm -rf ./$(PKG)/src/.{git,gitignore}
		@echo "Done."
