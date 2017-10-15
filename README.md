# Perl Modules 
A compilation of small Perl modules to help accomplish tasks in Perl

# INIReader.pm
A simple module which will read INI files and store them in a hash.

For example, if we have an INI file containing the following:

[setup]

db_host = localhost

To access the property 'db_host', we would use the following:
$ini->{setup}{db_host};

Assuming that we store the return value of read_ini() in a scalar called '$ini'.

You can force section names and property names either to uppercase or lowercase by using the following arguments in the constructor:

INIReader->new({force_uc => 1}); <-- this forces to uppercase

INIReader->new({force_lc => 1}); <-- this forces to lowercase
