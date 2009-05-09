use inc::Module::Install;

name          'Class-Accessor-Deep';
version       '0.01';
perl_version  '5.008';
all_from      'lib/Class/Accessor/Deep.pm';

requires      'Scalar::Util' => '1.19';

test_requires 'Test::Exception' => '0.27';

WriteAll;