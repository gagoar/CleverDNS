#class Request
package Request;
use Switch;
use Net::DNS;
use NetAddr::IP;
sub new{   
	my ($class,@values) = @_;
	my $self = {
				qname 	 => $values[0], 
				qclass	 => $values[1],
				qtype 	 => $values[2],
				id	 => $values[3],
				remoteip => $values[4],
				localip  => $values[5]
	};
	bless $self, $class;
	return $self;

sub warning{
	my ($self)=@_;
	warn "Qname is:",$self->{qname},"\n";
	warn ($self->{qname}.",".$self->{qclass}.", ".$self->{qtype}.", ".$self->{id}.", ".$self->{remoteip}.", ".$self->{localip}."\n");
}
sub show{
	my ($self)=@_;
	printf ($self->{qname}.",".$self->{qclass}.", ".$self->{qtype}.", ".$self->{id}.", ".$self->{remoteip}.", ".$self->{localip}."\n");
}

sub dig_local {
	my $FLAG=0;
	my ($self,$conf)=@_;
	my $qname=$self->{qname};
	my $cdir=undef;
	warn "entro a dig_local\n";
	$qname=~ s/\./_/g;
	if (defined($conf->{data}->[0]->{$qname}->{enabled})){
		my @As=undef;
		my $i=0;
		warn "obteniendo permisos sobre dominio\n";
		foreach $cidr (split(',', $conf->{data}->[0]->{$qname}->{allow})){
			$cidr=NetAddr::IP->new($cidr);
			warn "cidr a comprar: $cidr con ip remota:", $self->{remoteip}, "\n";
			if ($cidr->contains(NetAddr::IP->new($self->{remoteip}))) {
				warn "dominio en solucion local\n";
				@As=split(',',$conf->{data}->[0]->{$qname}->{A});
				print "DATA\t".$self->{qname}."\t".$self->{qclass}."\tA\t".$conf->{data}->[0]->{$qname}->{ttl}."\t".$self->{id}."\t".$As[$i]."\n";
				print "END\n";
				warn "DATA\t".$self->{qname}."\t".$self->{qclass}."\tA\t".$conf->{data}->[0]->{$qname}->{ttl}."\t".$self->{id}."\t".$As[$i]."\n";
				warn "END\n";
				$FLAG=1;
				last;
			}
			$i++;
		}

	}
return $FLAG;
}
sub dig_remote{
		my ($self, $ns, $port)=@_;
		$get=Net::DNS::Resolver->new;
		if ( $ns and $port )
		{
			$get->nameservers($ns);
			$get->port($port);
		}
		warn "Using nameservers:",  $get->nameservers , " on port " , $get->port, "\n";
		my $query;
		if ($self->{qtype} eq "SOA")
			 {$query=$get->query($self->{qname},"SOA");warn "its SOA\n";}
		else { $query=$get->search($self->{qname});warn "its A\n";}	
		if ($query) {
		foreach my $rr ($query->answer) {
			switch($rr->type){
				case "A" 	{
#							warn "registro A\n";
#							REGISTROS EQ A		
							print "DATA\t".$self->{qname}."\t".$rr->class."\t".$rr->type."\t".$rr->ttl."\t".$self->{id}."\t".$rr->address."\n";
							warn "DATA\t".$self->{qname}."\t".$rr->class."\t".$rr->type."\t".$rr->ttl."\t".$self->{id}."\t".$rr->address."\n";
							}
# 							REGISTROS EQ CNAME
				case "CNAME"{ 
#							warn "registro CNAME\n";
							warn "DATA\t".$self->{qname}."\t".$rr->class."\t".$rr->type."\t".$rr->ttl."\t".$self->{id}."\t".$rr->cname."\n";
							print "DATA\t".$self->{qname}."\t".$rr->class."\t".$rr->type."\t".$rr->ttl."\t".$self->{id}."\t".$rr->cname."\n";
							}
				case "SOA" {
# 							REGISTROS EQ SOA
#							warn "registro SOA\n";
							print "DATA\t".$self->{qname}."\t".$rr->class."\t".$rr->type."\t".$rr->ttl."\t".$self->{id}."\t".$rr->rname."\n";
							warn "DATA\t".$self->{qname}."\t".$rr->class."\t".$rr->type."\t".$rr->ttl."\t".$self->{id}."\t".$rr->rname."\n";
						   }
		
  			} 
		}
			print "END\n";
			warn  "END\n";			
		}	
			else {warn "query failed: ". $get->errorstring. "\n";
				#print "DATA\t".$self->{qname}."\t".$self->{qclass}."\t".$self->{qtype}."\t-1\t".$self->{id}."\t\n";
				warn "DATA\t".$self->{qname}."\t".$self->{qclass}."\t".$self->{qtype}."\t-1\t".$self->{id}."\t\n";
			     	warn "END\n";
			     	print "END\n";

				
			    }
	}
}
1;
