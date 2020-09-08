
function extendedgcd(a::Integer, b::Integer)
    sign_a, sign_b = sign(a), sign(b)
    s, old_s = 0, 1
    r, old_r = abs(b), abs(a)
    while r != 0
        quotient = old_r ÷ r
        (old_r, r) = (r, old_r - quotient * r)
        (old_s, s) = (s, old_s - quotient * s)
    end
    if b != 0
        bezout_t = (old_r - old_s * abs(a)) ÷ abs(b)
    else
        bezout_t = 0
    end
    return (old_r, [sign_a * old_s, sign_b * bezout_t])
end
