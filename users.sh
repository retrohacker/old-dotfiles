## get mini UID limit ##
l=$(grep "^UID_MIN" /etc/login.defs)

## get max UID limit ##
l1=$(grep "^UID_MAX" /etc/login.defs)

## use awk to print if UID >= $MIN and UID <= $MAX   ##
awk -F':' -v "min=${l##UID_MIN}" -v "max=${l1##UID_MAX}" '{ if ( ( $3 >= min && $3 <= max ) || $3 == 0 ) print $0}' /etc/passwd | cut -d ":" -f 1
