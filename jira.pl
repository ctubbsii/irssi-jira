#! /usr/bin/env perl
use strict;
use warnings;
use Getopt::Long qw( :config posix_default bundling no_ignore_case );
use Irssi;

our $VERSION = '0.1';
our %IRSSI = (
  authors     => 'Christopher Tubbs',
  contact     => 'https://github.com/ctubbsii',
  name        => 'Irssi JIRA Bot',
  description => 'A small irssi script for recommending links to possible ' .
                  'JIRA issues discussed in IRC',
  license     => 'BSD',
);

my $jira = 'https://issues.apache.org/jira';
my $jira_proj = 'ACCUMULO';
my $response_prefix = ''; # 'Possible JIRA mentioned: ';
my $test_message;
my $test_channel = 'test';
my @projects = ('ABDERA', 'ACCUMULO', 'ACE', 'ACL', 'ADDR', 'ADFFACES', 'AGILA', 'AIRAVATA', 'ALOIS', 'AMBARI', 'AMBER', 'AMQ', 'AMQCPP', 'AMQNET', 'ANAKIA', 'ANY23', 'APA', 'APACHECON', 'APLO', 'APOLLO', 'ARIES', 'ARMI', 'ASYNCWEB', 'ATTIC', 'ATTRIBUTES', 'AURORA', 'AUTOTAG', 'AVALON', 'AVNSHARP', 'AVRO', 'AWF', 'AXIOM', 'AXIS', 'AXIS2', 'AXIS2C', 'AXISCPP', 'BATCHEE', 'BATIK', 'BCEL', 'BEANUTILS', 'BEEHIVE', 'BETWIXT', 'BIGTOP', 'BLAZE', 'BLUESKY', 'BLUR', 'BOOKKEEPER', 'BSF', 'BUILDR', 'BVAL', 'CACTUS', 'CAMEL', 'CASSANDRA', 'CAY', 'CB', 'CELIX', 'CENTRAL', 'CHAIN', 'CHUKWA', 'CLEREZZA', 'CLI', 'CLIMATE', 'CLK', 'CLKE', 'CLOUDSTACK', 'CMIS', 'COCOON', 'COCOON3', 'CODEC', 'COLLECTIONS', 'COMDEV', 'COMMONSSITE', 'COMPRESS', 'CONFIGURATION', 'CONNECTORS', 'COUCHDB', 'CRUNCH', 'CSV', 'CTAKES', 'CURATOR', 'CXF', 'DAEMON', 'DATAFU', 'DAYTRADER', 'DBCP', 'DBF', 'DBUTILS', 'DDLUTILS', 'DELTASPIKE', 'DEPOT', 'DERBY', 'DIGESTER', 'DIR', 'DIRAPI', 'DIRECTMEMORY', 'DIRGROOVY', 'DIRKRB', 'DIRMINA', 'DIRNAMING', 'DIRSERVER', 'DIRSHARED', 'DIRSTUDIO', 'DIRTSEC', 'DISCOVERY', 'DISPATCH', 'DMAP', 'DORMANT', 'DOSGI', 'DRILL', 'DROIDS', 'DTACLOUD', 'DVSL', 'EASYANT', 'ECS', 'EL', 'EMAIL', 'EMPIREDB', 'ESCIMO', 'ESME', 'ETCH', 'EWS', 'EXEC', 'EXLBR', 'EXTCDI', 'EXTSCRIPT', 'EXTVAL', 'FALCON', 'FEDIZ', 'FEEDPARSER', 'FELIX', 'FILEUPLOAD', 'FLEX', 'FLUME', 'FOP', 'FOR', 'FORTRESS', 'FTPSERVER', 'FUNCTOR', 'GBUILD', 'GERONIMO', 'GERONIMODEVTOOLS', 'GIRAPH', 'GORA', 'GRFT', 'GSHELL', 'GUMP', 'HADOOP', 'HAMA', 'HARMONY', 'HBASE', 'HCATALOG', 'HDFS', 'HDT', 'HELIX', 'HERALDRY', 'HERMES', 'HISE', 'HIVE', 'HIVEMIND', 'HTTPASYNC', 'HTTPCLIENT', 'HTTPCORE', 'HTTPDRAFT', 'HUPA', 'IBATIS', 'IBATISNET', 'IMAGING', 'IMAP', 'IMPERIUS', 'INCUBATOR', 'INFRA', 'IO', 'ISIS', 'IVY', 'IVYDE', 'JACOB', 'JAMES', 'JAXME', 'JCI', 'JCLOUDS', 'JCR', 'JCRBENCH', 'JCRCL', 'JCRRMI', 'JCRSERVLET', 'JCRSITE', 'JCRTCK', 'JCRVLT', 'JCS', 'JDKIM', 'JDO', 'JELLY', 'JENA', 'JEXL', 'JS1', 'JS2', 'JSEC', 'JSIEVE', 'JSPF', 'JSPWIKI', 'JUDDI', 'JXPATH', 'KAFKA', 'KALUMET', 'KAND', 'KARAF', 'KATO', 'KI', 'KITTY', 'KNOX', 'LABS', 'LANG', 'LAUNCHER', 'LCN4C', 'LEGAL', 'LIBCLOUD', 'LOG4J2', 'LOG4NET', 'LOG4PHP', 'LOGCXX', 'LOGGING', 'LOKAHI', 'LUCENE', 'LUCENENET', 'LUCY', 'MAHOUT', 'MAILBOX', 'MAILET', 'MAPREDUCE', 'MARMOTTA', 'MASFRES', 'MATH', 'MAVIBOT', 'MESOS', 'METAMODEL', 'MFCOMMONS', 'MFHTML5', 'MIME4J', 'MIRAE', 'MODELER', 'MODPYTHON', 'MPOM', 'MPT', 'MRQL', 'MRUNIT', 'MTOMCAT', 'MUSE', 'MYFACES', 'MYFACESTEST', 'NEETHI', 'NET', 'NPANDAY', 'NUTCH', 'NUVEM', 'OAK', 'OCM', 'ODE', 'ODFTOOLKIT', 'OEP', 'OFBIZ', 'OGNL', 'OJB', 'OLINGO', 'OLIO', 'OLTU', 'ONAMI', 'OODT', 'OOZIE', 'OPENEJB', 'OPENJPA', 'OPENMEETINGS', 'OPENNLP', 'ORCHESTRA', 'ORP', 'OWB', 'PB', 'PDFBOX', 'PHOENIX', 'PHOTARK', 'PIG', 'PIVOT', 'PLANET', 'PLUTO', 'PNIX', 'PODLINGNAMESEARCH', 'POOL', 'PORTALS', 'PORTLETBRIDGE', 'POSTAGE', 'PRC', 'PRIMITIVES', 'PROTOCOLS', 'PROTON', 'PROVISIONR', 'PROXY', 'PYLUCENE', 'QPID', 'QPIDJMS', 'RAMPART', 'RAMPARTC', 'RAT', 'RAVE', 'RBATIS', 'RESOURCES', 'RIPPLE', 'RIVER', 'ROL', 'RUNTIME', 'S4', 'SAMZA', 'SAND', 'SANDBOX', 'SANDESHA2', 'SANDESHA2C', 'SANSELAN', 'SANTUARIO', 'SAVAN', 'SB', 'SCOUT', 'SCXML', 'SENTRY', 'SHALE', 'SHINDIG', 'SHIRO', 'SIRONA', 'SIS', 'SITE', 'SLING', 'SM', 'SMX4', 'SMX4KNL', 'SMX4NMR', 'SMXCOMP', 'SOAP', 'SOLR', 'SPARK', 'SQOOP', 'SSHD', 'STANBOL', 'STDCXX', 'STEVE', 'STOMP', 'STONEHENGE', 'STORM', 'STR', 'STRATOS', 'STREAMS', 'STUDIO', 'SYNAPSE', 'SYNCOPE', 'TAJO', 'TAP5', 'TAPESTRY', 'TASHI', 'TATPI', 'TENTACLES', 'TEVAL', 'TEXEN', 'TEZ', 'THRIFT', 'TIKA', 'TILES', 'TILESSB', 'TILESSHARED', 'TILESSHOW', 'TM', 'TOBAGO', 'TOMAHAWK', 'TOMEE', 'TOOLS', 'TORQUE', 'TORQUEOLD', 'TRANSACTION', 'TRANSPORTS', 'TRB', 'TREQ', 'TRINIDAD', 'TRIPLES', 'TS', 'TSIK', 'TST', 'TUSCANY', 'TWILL', 'UIMA', 'USERGRID', 'VALIDATOR', 'VCL', 'VELOCITY', 'VELOCITYSB', 'VELTOOLS', 'VFS', 'VXQUERY', 'VYSPER', 'WADI', 'WAVE', 'WEAVER', 'WHIRR', 'WHISKER', 'WICKET', 'WINK', 'WODEN', 'WOOKIE', 'WSCOMMONS', 'WSIF', 'WSRP4J', 'WSS', 'WW', 'XALANC', 'XALANJ', 'XAP', 'XBEAN', 'XERCESC', 'XERCESJ', 'XERCESP', 'XGC', 'XMLBEANS', 'XMLCOMMONS', 'XMLRPC', 'XMLSCHEMA', 'XW', 'YARN', 'YOKO', 'ZETACOMP', 'ZOOKEEPER');

sub irssi_jira_main {
  &parse_args();
  if ($test_message) {
    print 'Testing: ' . $test_message . "\n";
    &sig_message_public('dummy', $test_message, 'test_user', 'test_ip', '#' . $test_channel);
  } else {
    Irssi::signal_add('message public', 'sig_message_public');
  }
}

sub parse_args {
  GetOptions(
    't|test=s' => \$test_message,
    'c|channel=s' => \$test_channel,
  ) or die("Invalid test message\n");
}

sub respond_in_channel {
  my ($server, $channel, $response) = @_;
  my $line = 'msg ' . $channel . ' ' . $response;
  if ($test_message) {
    print $line . "\n";
  } else {
    $server->command($line);
  }
}

sub sig_message_public {
  my ($server, $msg, $nick, $nick_addr, $target) = @_;
  my $projline = join('|', @projects);
  if ($target =~ /^#(?:accumulo|test)$/) { # only operate in these channels
    foreach my $w ($msg =~ /(\S+)/g) {
      $w =~ s/[,.:;)]+$//; # remove trailing punctuation
      $w =~ s/^[(]+//; # remove leading parens
      if ($w =~ /^\d{4,5}$/) {
        &respond_in_channel($server, $target, "${response_prefix}$jira/browse/${jira_proj}-$w");
      } elsif ($w =~ /^(?:${projline})-\d{1,5}$/i) {
        &respond_in_channel($server, $target, "${response_prefix}$jira/browse/" . uc($w));
      }
    }
  }
}

&irssi_jira_main();
