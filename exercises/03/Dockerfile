FROM centos:7

RUN yum -y install initscripts which unzip wget net-tools less

COPY sapdownloads /tmp/sapdownloads/
WORKDIR /tmp/sapdownloads/

RUN unzip sapcc*.zip && \
	rpm -i sapjvm*.rpm && \
	rpm -i com.sap.scc*.rpm

RUN chsh -s /bin/bash sccadmin

EXPOSE 8443
USER sccadmin
WORKDIR /opt/sap/scc

CMD /opt/sapjvm_8/bin/java \
	-server \
	-XtraceFile=log/vm_@PID_trace.log \
	-XX:+GCHistory \
	-XX:GCHistoryFilename=log/vm_@PID_gc.prf \
	-XX:+HeapDumpOnOutOfMemoryError \
	-XX:+DisableExplicitGC \
	-Xms1024m \
	-Xmx1024m \
	-XX:MaxNewSize=512m \
	-XX:NewSize=512m \
	-XX:+UseConcMarkSweepGC \
	-XX:TargetSurvivorRatio=85 \
	-XX:SurvivorRatio=6 \
	-XX:MaxDirectMemorySize=2G \
	-Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=com.sap.scc.tomcat.utils.PropertyDigester \
	-Dosgi.requiredJavaVersion=1.6 \
	-Dosgi.install.area=. \
	-DuseNaming=osgi \
	-Dorg.eclipse.equinox.simpleconfigurator.exclusiveInstallation=false \
	-Dcom.sap.core.process=ljs_node \
	-Declipse.ignoreApp=true \
	-Dosgi.noShutdown=true \
	-Dosgi.framework.activeThreadType=normal \
	-Dosgi.embedded.cleanupOnSave=true \
	-Dosgi.usesLimit=30 \
	-Djava.awt.headless=true \
	-Dio.netty.recycler.maxCapacity.default=256 \
	-Djdk.tls.server.protocols=TLSv1.2 \
	-jar plugins/org.eclipse.equinox.launcher_1.1.0.v20100507.jar
