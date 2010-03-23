#!/usr/bin/perl -w
# sample PowerDNS Coprocess backend
#
BEGIN { push @INC, "/etc/powerdns/cleverdns/";}
use Request;
use Yamaling;
use strict;
use POSIX qw(strftime);

my $config_file="/etc/powerdns/cleverdns/file.yaml";
$|=1;# no buffering

my $line=<>;
chomp($line);

unless($line eq "HELO\t2") {
  print "FAIL\n";
  print STDERR "Recevied '$line'\n";
  <>;
  exit;
}
print "OK CleverDns ready\n";# print our banner
my $req;
my $type;
my $qname;
my $qclass;
my $qtype;
my $id;
my $remoteip;
my $localip;
my $conf=new Yamaling($config_file);
#my $conf=new Yamaling("/home/gagoar/dev/perl/cleverdns.stable/file.yaml");
$conf->load;
while(<>)
{
  print STDERR "$$ Received: $_";
  chomp();
  my @arr=split(/\t/);
 
  	if(@arr<6) {
     				if (@arr=2){warn "@arr\n";print "END\n";warn "END\n"}
					else { 	warn "@arr\n"; 
							warn "LOG:PowerDNS sent unparseable line\n";
      					   	warn "FAIL\n";
				 		 }
	          }
	else 	  { 
              	($type,$qname,$qclass,$qtype,$id,$remoteip,$localip)=@arr;
				if ($qname eq "da39a3ee5e6b4b0d3255bfef95601890afd80709" && $remoteip eq '127.0.0.1') {
					$conf->load;	
					warn "reloading configuration\n";
					print "DATA\t".$qname."\t".$qclass."\tA\t50\t$id\t".strftime("%S.%M.%H.%d",localtime())."\n";
					warn "DATA\t".$qname."\t".$qclass."\tA\t50\t$id\t".strftime("%S.%M.%H.%d",localtime())."\n";
					warn "END\n";print "END\n";
				}
				else {
					if ($qname eq "" or $qname =~ /^\B/ or  $qname =~ /^\d/ ) 
					{
						warn "qname empty\n";
						print "END\n";
					}
					else {
						$req=new Request($qname,$qclass,$qtype,$id,$remoteip,$localip);
			  			$req->warning;
						$req->dig_local($conf) or $req->dig_remote;
					     }
				}
			}
}
