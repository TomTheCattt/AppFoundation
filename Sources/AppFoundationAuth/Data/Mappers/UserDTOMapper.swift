import Foundation

public enum UserDTOMapper {
    public static func toEntity(_ dto: UserDTO) -> UserEntity {
        UserEntity(
            id: dto.id,
            email: dto.email,
            name: dto.name
        )
    }
}
