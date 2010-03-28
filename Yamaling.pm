#class Yamlaing
#===============================================================================
#
#         FILE:  Yamaling.pm
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  German Frigerio & Diego Nemitz (), xeroice at gmail.com
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  09/03/10 20:10:14
#     REVISION:  ---
#===============================================================================
package Yamaling;
use strict;
use warnings;
use YAML::Tiny;
use Error qw(:try);
sub new{   
	my ($class,$file) = @_;
	my $self = {
				nom_file 	 => $file, 
				data  		 => undef
	};
	bless $self, $class;
	return $self;

sub load{
		my ($self)=@_;
		$self->{data}=YAML::Tiny->read($self->{nom_file});
}
}
1;
