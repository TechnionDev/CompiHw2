
set -e

# For each file in hw1-tests, run the test and print the result
for file in hw2-tests/*.in
do
    echo "Running test $file"
    # Remove extension
    baseName="hw2-tests/$(basename "$file" .in)"
    # Run and ignore status code
    ./hw2 < $file > $baseName.res 2| echo ""
    diff $baseName.out $baseName.res 2>&1
done

echo "All tests done. Good job!"