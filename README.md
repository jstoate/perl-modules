# Perl Modules 
A compilation of small Perl modules to help accomplish tasks in Perl.

I've tried my best to comment code as much as possible to help you understand what the different arguments etc does. The module names should be quite descriptive so you know what the module does (for example, INIReader.pm reads INI files).

<<<<<<< HEAD
Hopefully you find these modules useful. Feel free to use them and modify them as you want.
=======
For example, if we have an INI file containing the following:

[setup]

db_host = localhost

To access the property 'db_host', we would use the following:
$ini->{setup}{db_host};

Assuming that we store the return value of read_ini() in a scalar called '$ini'.

You can force section names and property names either to uppercase or lowercase by using the following arguments in the constructor:

INIReader->new({force_uc => 1}); <-- this forces to uppercase

INIReader->new({force_lc => 1}); <-- this forces to lowercase
>>>>>>> ef7d9d21a6ba45351e6a2fe9db874a813bd27b24
