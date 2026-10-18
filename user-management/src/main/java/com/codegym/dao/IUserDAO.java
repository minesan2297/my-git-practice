package com.codegym.dao;

import com.codegym.model.User;
import java.util.List;

public interface IUserDAO {
    void insertUser(User user) throws Exception;
    User selectUser(int id);
    List<User> selectAllUsers();
    boolean deleteUser(int id) throws Exception;
    boolean updateUser(User user) throws Exception;
    List<User> findByCountry(String country);
    List<User> sortByName(String order);
    User getUserById(int id);
    void insertUserStore(User user) throws Exception;
    void addUserTransaction(User user, int[] permissionIds) throws Exception;
    void insertUpdateWithoutTransaction();
}
