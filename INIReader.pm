package INIReader;

use strict;
use warnings;
use Data::Dumper;
use Carp;

###############################################
# A simple Perl module for reading INI files. #
###############################################

# ----------------------------------------- #
sub new {
	my $class = shift;
	my $args = shift;
	my $self =	{
					force_uc	=> 0, # forces section names and property names to be uppercase
									  # note: this does not include values.
					force_lc	=> 0, # similar to force_uc, this forces the section names and
									  # property names to lower case.
				};

	if (ref($args) eq 'HASH') {
		foreach my $arg (keys %{$args}) {
			if (exists $self->{$arg}) {
				$self->{$arg} = $args->{$arg};
			}
			else {
				confess("Unknown argument: '$arg'.");
			}
		}
	}
	elsif (defined $args) {
		# Looks like the arguments aren't a hash
		confess("Arguments passed in is not in a hash structure.");
	}

	# Perform a quick sanity check on the arguments
	if ($self->{force_uc} && $self->{force_lc}) {
		confess("force_uc and force_lc has been both enabled. You can only select one of these options.");
	}

	bless $self, $class;
	return $self;
}
# ----------------------------------------- #
sub read_ini {
	my $self = shift;
	my ($file) = @_;

	my $current_section;	
	my $contents = {};

	open(my $FILE, '<', $file) || confess("Could not open '$file': $!");
	# First, we store the entire contents of the file to memory
	while (my $line = <$FILE>) {
		chomp $line;

		# Skip empty lines
		if ($line !~ /\w+/i) {
			next;
		}

		# Remove comments so we don't process them
		$line = $self->_remove_comments($line);

		# Check if this is a section 
		my $section_name = $self->_check_for_section($line);
		if ($section_name) {
			# Looks like this is a section
			$current_section = $section_name;
			if ($self->{force_uc}) {
				$current_section = uc $current_section;
			}
			elsif ($self->{force_lc}) {
				$current_section = lc $current_section;
			}
			next;
		}

		# Check if this is a property
		my ($property, $value) = $self->_check_for_property($line);
		if ($property && $value) {
			if ($self->{force_uc}) {
				$property = uc $property;
			}
			elsif ($self->{force_lc}) {
				$property = lc $property;
			}
			$contents->{$current_section}{$property} = $value;
			next;
		}
	}
	close($FILE);

	return $contents;
}
# ----------------------------------------- #
sub _remove_comments {
	my $self = shift;
	my ($line) = @_;
	# All this does is remove comments
	# from the INI file so we don't read the comments.
	# In INI files, comments are denoted by the ';' character.

	$line =~ s/;.+//g;

	return $line;
}
# ----------------------------------------- #
sub _check_for_section {
	my $self = shift;
	my ($line) = @_;
	# This will check if the line contains a section, i.e. [section]

	if ($line =~ /\[(.+)\]/) {
		# This is a section
		return $1; # Returns the name of the section
	}

	return undef; 
}
# ----------------------------------------- #
sub _check_for_property {
	my $self = shift;
	my ($line) = @_;
	# This will check if the line contains a property i.e. property=value

	if ($line =~ /(.+)=(.+)/) {
		# Looks like we do have a property
		my $property = $self->_trim($1);
		my $value = $self->_trim($2);
		return $property, $value;
	}
	
	return undef;
}
# ----------------------------------------- #
sub _trim {
	my $self = shift;
	my ($text) = @_;
	# This will trim white space

	$text =~ s/^\s+//g;
	$text =~ s/\s+$//g;

	return $text;
}
# ----------------------------------------- #
1;
