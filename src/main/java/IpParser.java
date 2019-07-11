import org.apache.commons.net.util.SubnetUtils;
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.io.Text;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;

public class IpParser extends UDF {

    public boolean evaluate(Text ip, Text range) {
        try {
            return getHighAddress(range.toString()) >= ipv4ToLong(ip.toString())
                    && ipv4ToLong(ip.toString()) >= getLowAddress(range.toString());
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    private long getLowAddress(String range) throws UnknownHostException{
        return ipv4ToLong(new SubnetUtils(range).getInfo().getLowAddress());
    }

    private long getHighAddress(String range) throws UnknownHostException{
        return ipv4ToLong(new SubnetUtils(range).getInfo().getHighAddress());
    }

    private long ipv4ToLong(String ip) throws UnknownHostException {
        InetAddress inetAddressOrigin = InetAddress.getByName(ip);
        return ByteBuffer.wrap(inetAddressOrigin.getAddress()).getLong();

    }
}

