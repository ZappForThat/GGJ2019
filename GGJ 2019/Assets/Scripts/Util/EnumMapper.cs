using System.Collections.Generic;

public interface EnumMapper<MappedType>
{
    List<MappedType> GetMap();
}
