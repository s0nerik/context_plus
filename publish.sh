for dir in packages/*; do (rsync -av --no-links --exclude='build' --exclude='.dart_tool' --exclude='.idea' 'example/' "$dir/example"); done
melos publish "$@"
for dir in packages/*; do (rm -rf "$dir/example"); done
