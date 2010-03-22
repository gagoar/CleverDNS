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
sub dig_local{
		my ($self,$dom,$type)=@_;
		my $qname=$dom;
		$qname=~ s/\./_/g;
		if (defined($self->{data}->[0]->{$qname}->{enabled})){
		warn "dominio en resolucion local\n";
		print "DATA\t".$dom."\tIN\t".$type."\t".$self->{data}->[0]->{$qname}->{ttl}."\t1\t".$self->{data}->[0]->{$qname}->{$type}."\n";
		warn "DATA\t".$dom."\tIN\t".$type."\t".$self->{data}->[0]->{$qname}->{ttl}."\t1\t".$self->{data}->[0]->{$qname}->{$type}."\n";
		print "END\n";
		}
	}
}
1;
