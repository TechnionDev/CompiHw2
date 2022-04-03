
set -e

# For each file in hw1-tests, run the test and print the result
for file in hw1-tests/*.in
do
    echo "Running test $file"
    # Remove extension
    baseName="hw1-tests/$(basename "$file" .in)"
    ./hw1.out < $file > $baseName.res
    diff $baseName.out $baseName.res
done

echo "Running outsourced tests (accuired from the group)"

for file in hw1-tests/outsourced/*.in
do
    echo "Running test $file"
    # Remove extension
    baseName="hw1-tests/outsourced/$(basename "$file" .in)"
    ./hw1.out < $file > $baseName.res
    diff $baseName.out $baseName.res
done

echo "All tests done. Good job!"