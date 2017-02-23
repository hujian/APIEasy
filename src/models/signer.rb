# coding = utf-8

require 'openssl'
require 'base64'

class Signer
  def encrypt(message, password)
    Base64.encode64(self.encrypt_data(message.to_s.strip, self.key_digest(password), nil, "AES-128-ECB"))
  end

  def decrypt_with_password(message, password)
    base64_decoded = Base64.decode64(message.to_s.strip)
    aes = self.decrypt_data(base64_decoded, password, nil, "AES-128-ECB")
    resutl = Base64.decode64(aes)
  end

  def decrypt(message)
      self.decrypt_with_password(message, 'bocai53s1c46c87p')
  end

  def key_digest(password)
    OpenSSL::Digest::SHA256.new(password).digest
  end

  # Decrypts a block of data (encrypted_data) given an encryption key
  # and an initialization vector (iv).  Keys, iv's, and the data
  # returned are all binary strings.  Cipher_type should be
  # "AES-256-CBC", "AES-256-ECB", or any of the cipher types
  # supported by OpenSSL.  Pass nil for the iv if the encryption type
  # doesn't use iv's (like ECB).
  #:return: => String
  #:arg: encrypted_data => String
  #:arg: key => String
  #:arg: iv => String
  #:arg: cipher_type => String
  def decrypt_data(encrypted_data, key, iv, cipher_type)
    aes = OpenSSL::Cipher::Cipher.new(cipher_type)
    aes.decrypt
    aes.key = key
    aes.padding = 0
    aes.iv = iv if iv != nil
    aes.update(encrypted_data) + aes.final
  end

  # Encrypts a block of data given an encryption key and an
  # initialization vector (iv).  Keys, iv's, and the data returned
  # are all binary strings.  Cipher_type should be "AES-256-CBC",
  # "AES-256-ECB", or any of the cipher types supported by OpenSSL.
  # Pass nil for the iv if the encryption type doesn't use iv's (like
  # ECB).
  #:return: => String
  #:arg: data => String
  #:arg: key => String
  #:arg: iv => String
  #:arg: cipher_type => String
  def encrypt_data(data, key, iv, cipher_type)
    aes = OpenSSL::Cipher::Cipher.new(cipher_type)
    aes.encrypt
    aes.key = key
    aes.iv = iv if iv != nil
    aes.update(data) + aes.final
  end
end

# s = Signer.new
# message = 'pVcreL1BP07uCcZQJUGcd2RXOpU6MLK/vzRXwYbX85ALskUxZY/iqcmHkBeLZiqzFbRDXiRe9KerYz8wbl1UB5sRFQptphtf560Wscfw8DDIRvjERrfSgmo9UPmslDEgpqmahRqj93UtpaFkWBNJJDXtXnYoZ82MSdWc5QGpWingPEMtmsoIrEU9rir8I0iYxwCoggjmNQ4qYKR0KEduZXQ8t5oJPu60KyYi9jcyUAEkdIkDVVBZYgAtCyMdvF9cphhHQG88XhznAj/lFEpSnmcYM5qgDe5JFl/baXhOpCg3hgP0KwKV4QWEK15dPRJy7I0/JAdShWNDtuc923cKBmeWImxkXYxwBYCESNg1sEWBQOLzpXI%2BhUm8Qp1YOUhY'
# key = 'bocai53s1c46c87p'
# puts s.decrypt(message, key)
