function VC8_disconnect(sp)

if strcmp(class(sp), 'internal.Serialport')
    delete(sp);
end