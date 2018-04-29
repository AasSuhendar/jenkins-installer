import hudson.model.*;
import jenkins.model.*;

Thread.start {
      sleep 10000
      println "--> Setting Agent Port for JNLP"
      def env = System.getenv()
      int port = env['JENKINS_SLAVE_AGENT_PORT'].toInteger()
      Jenkins.instance.setSlaveAgentPort(port)
      println "--> Done"
}