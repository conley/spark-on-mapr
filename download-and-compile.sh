#!/bin/bash

if [ ! -f spark-0.8.0-incubating.tgz ]; then
	wget http://spark-project.org/download/spark-0.8.0-incubating.tgz
fi
tar -xzf spark-0.8.0-incubating.tgz
cd spark-0.8.0-incubating

sed -i.bak 's|git:|https:|' project/project/SparkPluginBuild.scala
sed -i.bak \
  -e 's|DEFAULT_HADOOP_VERSION = "1.0.4"|DEFAULT_HADOOP_VERSION = "1.0.3-mapr-3.0.1"|' \
  -e '/"JBoss Repository"/i \
     "mapr-releases" at "http://repository.mapr.com/maven/",' \
  -e '/val excludeNetty = ExclusionRule(organization = "org.jboss.netty")/i \
  val excludeMapRNetty = ExclusionRule(name = "netty")' \
  -e '/val excludeNetty = ExclusionRule(organization = "org.jboss.netty")/i \
  val excludeMapRS3 = ExclusionRule(name = "s3filesystem")' \
  -e '/"org.apache.hadoop" % "hadoop-client" % hadoopVersion excludeAll(excludeJackson, excludeNetty, excludeAsm),/i \
      "com.mapr.hadoop" % "maprfs" % "1.0.3-mapr-3.0.1" excludeAll(excludeMapRNetty, excludeMapRS3),' \
  -e '/"org.apache.hadoop" % "hadoop-client" % hadoopVersion excludeAll(excludeJackson, excludeNetty, excludeAsm),/c \
      "org.apache.hadoop" % "hadoop-all" % hadoopVersion excludeAll(excludeJackson, excludeNetty, excludeAsm, excludeMapRS3),' \
  project/SparkBuild.scala
	
sbt/sbt package
